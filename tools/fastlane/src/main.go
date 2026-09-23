//
//  main.go
//  tools/fastlane
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-22
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

// pathRefs maps each platform to the config values that are repo-relative file
// paths: [block, key]. When the referenced file exists it is copied next to
// the Fastfile and the emitted value is replaced with its basename.
var pathRefs = map[string][][2]string{
	"xcode":   {{"deliver", "app_rating_config_path"}},
	"android": {{"appfile", "json_key_file"}},
}

func run(args []string) error {
	fs := flag.NewFlagSet("fastlane", flag.ContinueOnError)
	xcodeConfig := fs.String("xcode-config", "build/xcode/config/store.jsonc", "path to the merged Xcode store.jsonc")
	androidConfig := fs.String("android-config", "build/android/config/store.jsonc", "path to the merged Android store.jsonc")
	xcodeOut := fs.String("xcode-out", "build/xcode/fastlane", "path to the generated Xcode fastlane directory")
	androidOut := fs.String("android-out", "build/android/fastlane", "path to the generated Android fastlane directory")
	xcodeSources := fs.String("xcode-sources", "build/xcode/sources", "path to the assembled Xcode source tree")
	androidSources := fs.String("android-sources", "build/android/sources", "path to the assembled Android source tree")
	if err := fs.Parse(args); err != nil {
		return err
	}

	if err := generate("xcode", *xcodeConfig, *xcodeOut, *xcodeSources); err != nil {
		return fmt.Errorf("xcode: %w", err)
	}
	if err := generate("android", *androidConfig, *androidOut, *androidSources); err != nil {
		return fmt.Errorf("android: %w", err)
	}
	return nil
}

// generate parses the merged store.jsonc, renders the Fastlane files into out
// and mirrors that directory into <sources>/fastlane.
func generate(platform, configPath, out, sources string) error {
	cfg, err := parseConfig(configPath)
	if err != nil {
		return err
	}
	if err := copyPathFiles(platform, cfg, out); err != nil {
		return err
	}
	switch platform {
	case "xcode":
		err = renderXcode(cfg, out)
	default:
		err = renderAndroid(cfg, out)
	}
	if err != nil {
		return err
	}
	return mirrorOut(out, filepath.Join(sources, "fastlane"))
}

func parseConfig(path string) (map[string]any, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return parseConfigJSON(data)
}

func parseConfigJSON(data []byte) (map[string]any, error) {
	var cfg map[string]any
	if err := json.Unmarshal(stripJSONC(data), &cfg); err != nil {
		return nil, err
	}
	return cfg, nil
}

// copyPathFiles copies the referenced key files into out (next to the
// Fastfile) and rewrites the config value to the basename. A missing file is
// not an error: the value is emitted verbatim and a warning printed.
func copyPathFiles(platform string, cfg map[string]any, out string) error {
	for _, ref := range pathRefs[platform] {
		block, key := ref[0], ref[1]
		obj, ok := cfg[block].(map[string]any)
		if !ok {
			continue
		}
		value, ok := obj[key].(string)
		if !ok || value == "" {
			continue
		}
		data, err := os.ReadFile(value)
		if err != nil {
			fmt.Fprintf(os.Stderr, "warning: %s: %v; emitting %q verbatim\n", value, err, value)
			continue
		}
		if err := os.MkdirAll(out, 0755); err != nil {
			return err
		}
		name := filepath.Base(value)
		if err := os.WriteFile(filepath.Join(out, name), data, 0644); err != nil {
			return err
		}
		obj[key] = name
	}
	return nil
}

//
// Ruby rendering
//

// rubyValue renders a config value as a Ruby literal. Strings use Go quoting,
// which covers the escapes Fastlane metadata needs. Nested hashes are one
// level deep (submission_information) and sorted for determinism.
func rubyValue(v any) string {
	switch t := v.(type) {
	case string:
		return strconv.Quote(t)
	case bool:
		return strconv.FormatBool(t)
	case float64:
		return strconv.FormatFloat(t, 'f', -1, 64)
	case map[string]any:
		keys := make([]string, 0, len(t))
		for k := range t {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		var b strings.Builder
		b.WriteString("{\n")
		for i, k := range keys {
			if i > 0 {
				b.WriteString(",\n")
			}
			fmt.Fprintf(&b, "  %s: %s", k, rubyValue(t[k]))
		}
		b.WriteString("\n}")
		return b.String()
	default:
		return fmt.Sprintf("%v", v)
	}
}

// rubyLine renders a Fastlane config file entry: name(value).
func rubyLine(name string, v any) string {
	return name + "(" + rubyValue(v) + ")"
}

// rubyArgs returns the "key: value" keyword arguments for one block in a fixed
// key order. The multiline submission_information value keeps its own shape.
func rubyArgs(keys []string, block map[string]any) []string {
	args := []string{}
	for _, k := range keys {
		if v, ok := block[k]; ok {
			args = append(args, fmt.Sprintf("%s: %s", k, rubyValue(v)))
		}
	}
	return args
}

// action renders a Fastlane action call indented for a lane body (call at 4
// spaces, arguments at 6), matching the Fastlane documentation style.
func action(name string, args []string) string {
	if len(args) == 0 {
		return "    " + name
	}
	lines := make([]string, 0, len(args))
	for _, a := range args {
		lines = append(lines, "      "+a)
	}
	return "    " + name + "(\n" + strings.Join(lines, ",\n") + "\n    )"
}

// argvLines renders a config file as name(value) lines, in the given key order.
func argvLines(keys []string, block map[string]any) []string {
	out := []string{}
	for _, k := range keys {
		if v, ok := block[k]; ok {
			out = append(out, rubyLine(k, v))
		}
	}
	return out
}

func block(cfg map[string]any, name string) map[string]any {
	if cfg == nil {
		return nil
	}
	if b, ok := cfg[name].(map[string]any); ok {
		return b
	}
	return nil
}

func writeFile(path, content string) error {
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	return os.WriteFile(path, []byte(content), 0644)
}

//
// Xcode
//

var xcodeAppfileKeys = []string{"app_identifier", "apple_id", "team_id", "itc_team_id", "team_name"}
var deliverKeys = []string{
	"platform", "edit_live", "skip_binary_upload", "skip_screenshots",
	"skip_metadata", "skip_app_version_update", "force", "phased_release",
	"reset_ratings", "price_tier", "app_rating_config_path", "submission_information",
}
var matchKeys = []string{"type", "storage_mode", "git_url", "shallow_clone", "readonly"}
var gymKeys = []string{"scheme", "clean", "export_method"}

// xcodeMeta maps store metadata keys to the Deliver metadata file names.
var xcodeMeta = [][2]string{
	{"title", "name.txt"},
	{"subtitle", "subtitle.txt"},
	{"promotional_text", "promotional_text.txt"},
	{"description", "description.txt"},
	{"keywords", "keywords.txt"},
	{"privacy_url", "privacy_url.txt"},
	{"support_url", "support_url.txt"},
	{"marketing_url", "marketing_url.txt"},
	{"release_notes", "release_notes.txt"},
}

func renderXcode(cfg map[string]any, out string) error {
	if err := writeConfigFile(out, "Appfile", argvLines(xcodeAppfileKeys, block(cfg, "appfile"))); err != nil {
		return err
	}
	if err := writeConfigFile(out, "Deliverfile", argvLines(deliverKeys, block(cfg, "deliver"))); err != nil {
		return err
	}
	if err := writeConfigFile(out, "Matchfile", argvLines(matchKeys, block(cfg, "match"))); err != nil {
		return err
	}
	if err := writeFile(filepath.Join(out, "Fastfile"), xcodeFastfile(cfg)); err != nil {
		return err
	}
	return writeMetadata(out, "metadata", cfg, xcodeMeta, false)
}

// xcodeFastfile renders the Xcode lanes. match and gym come from their blocks;
// deliver carries the full deliver block. Non-runnable without store config.
func xcodeFastfile(cfg map[string]any) string {
	match := action("match", rubyArgs(matchKeys, block(cfg, "match")))
	gym := action("gym", rubyArgs(gymKeys, block(cfg, "gym")))
	deliver := action("deliver", rubyArgs(deliverKeys, block(cfg, "deliver")))
	return fmt.Sprintf(`default_platform(:ios)

platform :ios do
  desc "Sync signing certificates"
  lane :certificates do
%s
  end

  desc "Build and archive the iOS application"
  lane :build do
%s
%s
  end

  desc "Deploy a new version to the Apple App Store"
  lane :release do
%s
%s
  end
end
`, match, "    certificates", gym, "    build", deliver)
}

//
// Android
//

var androidAppfileKeys = []string{"json_key_file", "package_name"}
var supplyKeys = []string{
	"track", "rollout", "skip_upload_apk", "skip_upload_aab",
	"skip_upload_metadata", "skip_upload_changelogs", "skip_upload_images",
	"skip_upload_screenshots", "validate_only", "changes_not_sent_for_review",
	"ack_bundle_installation_warning",
}
var gradleKeys = []string{"task", "build_type"}

// androidMeta maps store metadata keys to the Supply metadata file names.
var androidMeta = [][2]string{
	{"title", "title.txt"},
	{"short_description", "short_description.txt"},
	{"description", "full_description.txt"},
	{"video", "video.txt"},
}

func renderAndroid(cfg map[string]any, out string) error {
	if err := writeConfigFile(out, "Appfile", argvLines(androidAppfileKeys, block(cfg, "appfile"))); err != nil {
		return err
	}
	if err := writeConfigFile(out, "Supplyfile", argvLines(supplyKeys, block(cfg, "supply"))); err != nil {
		return err
	}
	if err := writeFile(filepath.Join(out, "Fastfile"), androidFastfile(cfg)); err != nil {
		return err
	}
	return writeMetadata(out, "metadata/android", cfg, androidMeta, true)
}

// androidFastfile renders the Android lanes. gradient pairs with the gradle
// block; supply carries the full supply block.
func androidFastfile(cfg map[string]any) string {
	gradle := action("gradle", rubyArgs(gradleKeys, block(cfg, "gradle")))
	supply := action("supply", rubyArgs(supplyKeys, block(cfg, "supply")))
	return fmt.Sprintf(`default_platform(:android)

platform :android do
  desc "Build the Android App Bundle"
  lane :build do
%s
  end

  desc "Deploy a new version to the Google Play Store"
  lane :release do
%s
%s
  end
end
`, gradle, "    build", supply)
}

//
// Metadata
//

// writeMetadata writes localized store listing files under out/<subdir>/<locale>/
// for every locale in metadata (the default_language string is skipped). Files
// are only created for present non-empty values, so a rerun stays byte-stable.
// The Android renderer also writes the release_notes changelog for supply.
func writeMetadata(out, subdir string, cfg map[string]any, meta [][2]string, changelogs bool) error {
	block := block(cfg, "metadata")
	if block == nil {
		return nil
	}
	for locale, raw := range block {
		m, ok := raw.(map[string]any)
		if !ok {
			continue
		}
		dir := filepath.Join(out, subdir, locale)
		for _, f := range meta {
			value, ok := m[f[0]].(string)
			if !ok || value == "" {
				continue
			}
			if err := writeFile(filepath.Join(dir, f[1]), value); err != nil {
				return err
			}
		}
		if !changelogs {
			continue
		}
		if value, ok := m["release_notes"].(string); ok && value != "" {
			if err := writeFile(filepath.Join(dir, "changelogs", "default.txt"), value); err != nil {
				return err
			}
		}
	}
	return nil
}

func writeConfigFile(out, name string, lines []string) error {
	if len(lines) == 0 {
		return nil
	}
	return writeFile(filepath.Join(out, name), strings.Join(lines, "\n")+"\n")
}

//
// Mirror
//

// mirrorOut makes dst an exact copy of src: files are copied byte-stable and
// files present in dst but not in src are removed, so reruns stay no-ops and
// stale fastlane files never linger in the assembled project.
func mirrorOut(src, dst string) error {
	kept := map[string]bool{}
	if err := filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}
		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		kept[rel] = true
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		target := filepath.Join(dst, rel)
		if cur, err := os.ReadFile(target); err == nil && string(cur) == string(data) {
			return nil
		}
		if err := os.MkdirAll(filepath.Dir(target), 0755); err != nil {
			return err
		}
		return os.WriteFile(target, data, 0644)
	}); err != nil {
		return err
	}
	if _, err := os.Stat(dst); err != nil {
		if os.IsNotExist(err) {
			return nil
		}
		return err
	}
	return filepath.Walk(dst, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}
		rel, err := filepath.Rel(dst, path)
		if err != nil {
			return err
		}
		if kept[rel] {
			return nil
		}
		return os.Remove(path)
	})
}

// stripJSONC removes comments and trailing commas while keeping strings intact.
func stripJSONC(data []byte) []byte {
	var out []byte
	inStr := false
	for i := 0; i < len(data); i++ {
		c := data[i]
		if inStr {
			out = append(out, c)
			if c == '\\' {
				i++
				if i < len(data) {
					out = append(out, data[i])
				}
			} else if c == '"' {
				inStr = false
			}
			continue
		}
		switch c {
		case '"':
			inStr = true
			out = append(out, c)
		case '/':
			if i+1 < len(data) && data[i+1] == '/' {
				for i < len(data) && data[i] != '\n' {
					i++
				}
			} else if i+1 < len(data) && data[i+1] == '*' {
				i += 2
				for i+1 < len(data) && !(data[i] == '*' && data[i+1] == '/') {
					i++
				}
				i++
			} else {
				out = append(out, c)
			}
		case ',':
			j := i + 1
			for j < len(data) && (data[j] == ' ' || data[j] == '\t' || data[j] == '\n' || data[j] == '\r') {
				j++
			}
			if j < len(data) && (data[j] == '}' || data[j] == ']') {
				continue
			}
			out = append(out, c)
		default:
			out = append(out, c)
		}
	}
	return out
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
