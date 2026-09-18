//
//  tools/plugins/main.go
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-17
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
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

type platform string

const (
	platformXcode   platform = "xcode"
	platformAndroid platform = "android"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("plugins", flag.ContinueOnError)
	xcodeConfig := fs.String("xcode", "", "path to the merged Xcode config.jsonc")
	androidConfig := fs.String("android", "", "path to the merged Android config.jsonc")
	ignorePlatform := fs.Bool("ignore-platform", false, "keep other-platform plugin entries in the config files instead of deleting them")
	xcodeTemplate := fs.String("xcode-template", "sources/xcode/Application/Application/Plugins.swift", "path to the Plugins.swift template")
	androidTemplate := fs.String("android-template", "sources/android/Application/src/main/java/com/jasonelle/application/Plugins.kt", "path to the Plugins.kt template")
	if err := fs.Parse(args); err != nil {
		return err
	}

	if *xcodeConfig == "" || *androidConfig == "" {
		return errors.New("--xcode and --android are required")
	}

	used, err := copyPlugins(platformXcode, *xcodeConfig, *ignorePlatform)
	if err != nil {
		return err
	}
	if err := writeGenerated(platformXcode, *xcodeTemplate, used); err != nil {
		return err
	}

	used, err = copyPlugins(platformAndroid, *androidConfig, *ignorePlatform)
	if err != nil {
		return err
	}
	return writeGenerated(platformAndroid, *androidTemplate, used)
}

// copyPlugins resolves every plugin in the config for the given platform and
// copies its directory into build/<platform>/sources/. Unless ignore is set,
// entries that target the other platform are removed from the config file. It
// returns the plugins used for the platform (config key -> resolved name).
func copyPlugins(plat platform, configPath string, ignore bool) (map[string]string, error) {
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, err
	}
	var cfg map[string]any
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, fmt.Errorf("%s: %w", configPath, err)
	}

	plugins := map[string]string{}
	if raw, ok := cfg["plugins"].(map[string]any); ok {
		for key, v := range raw {
			ref, ok := v.(string)
			if !ok {
				return nil, fmt.Errorf("%s: plugin %q is not a string", configPath, key)
			}
			plugins[key] = ref
		}
	}

	destDir := filepath.Join("build", string(plat), "sources")
	if err := os.RemoveAll(destDir); err != nil {
		return nil, err
	}
	if err := os.MkdirAll(destDir, 0755); err != nil {
		return nil, err
	}

	used := map[string]string{}
	dropped := []string{}
	for key, ref := range plugins {
		src, name, ok, err := pluginSrcDir(plat, key, ref)
		if err != nil {
			return nil, fmt.Errorf("%s plugin %q: %w", plat, key, err)
		}
		if !ok {
			dropped = append(dropped, key)
			continue
		}
		used[key] = name
		if err := copyDir(src, filepath.Join(destDir, name)); err != nil {
			return nil, fmt.Errorf("plugin %q: %w", key, err)
		}
	}

	if !ignore && len(dropped) > 0 {
		if raw, ok := cfg["plugins"].(map[string]any); ok {
			for _, key := range dropped {
				delete(raw, key)
			}
		}
		out, err := json.MarshalIndent(cfg, "", "  ")
		if err != nil {
			return nil, err
		}
		if err := os.WriteFile(configPath, append(out, '\n'), 0644); err != nil {
			return nil, err
		}
	}
	return used, nil
}

// writeGenerated produces a filtered copy of the plugin composition template
// for a platform and writes it under build/<platform>/sources/, mirroring the
// template path relative to sources/<platform>/. Only the plugins in use.
func writeGenerated(plat platform, template string, used map[string]string) error {
	rel, err := filepath.Rel(".", template)
	if err != nil {
		return err
	}
	prefix := filepath.Join("sources", string(plat)) + string(filepath.Separator)
	if !strings.HasPrefix(rel, prefix) {
		return fmt.Errorf("%s template must live under sources/%s/: %s", plat, plat, template)
	}

	data, err := os.ReadFile(template)
	if err != nil {
		return err
	}

	required := map[string]bool{markerImport: true, markerInit: true}
	if plat == platformAndroid {
		required = map[string]bool{markerVars: true, markerMap: true}
	}

	content, err := filterMarkedBlocks(string(data), used, required, func(marker string, unknown []string) ([]string, error) {
		return synthLines(plat, used, marker, unknown)
	})
	if err != nil {
		return err
	}

	out := filepath.Join("build", string(plat), "sources", strings.TrimPrefix(rel, prefix))
	if err := os.MkdirAll(filepath.Dir(out), 0755); err != nil {
		return err
	}
	return os.WriteFile(out, []byte(content), 0644)
}

const (
	markerImport = "// PLUGINS.IMPORT.EXTRA"
	markerInit   = "// PLUGINS.INIT.EXTRA"
	markerVars   = "// PLUGINS.INIT.EXTRA.VARS"
	markerMap    = "// PLUGINS.INIT.EXTRA.MAP"
)

// filterMarkedBlocks copies the template verbatim, dropping the body of every
// // PLUGIN:<key> ... // ENDPLUGIN block whose key is not in use, and removing
// the marker lines themselves. Used keys that have no block are synthesized:
// emit is called once per EXTRA marker present in the template and must return
// the registration lines for those plugins. Errors on malformed markers, and
// when a used key has no block while the template lacks one of the markers in
// required (each platform must carry its own markers).
func filterMarkedBlocks(template string, used map[string]string, required map[string]bool, emit func(marker string, unknown []string) ([]string, error)) (string, error) {
	all := lines(template)

	// Validate the markers and collect used keys, found blocks and EXTRA lines.
	found := map[string]bool{}
	marked := map[string]bool{}
	inBlock := false
	for i, line := range all {
		trimmed := strings.TrimSpace(line)
		switch {
		case strings.HasPrefix(trimmed, "// PLUGIN:"):
			if inBlock {
				return "", fmt.Errorf("nested plugin block at line %d", i+1)
			}
			key := strings.TrimSpace(strings.TrimPrefix(trimmed, "// PLUGIN:"))
			if key == "" {
				return "", fmt.Errorf("empty plugin key at line %d", i+1)
			}
			inBlock = true
			found[key] = true
		case trimmed == "// ENDPLUGIN":
			if !inBlock {
				return "", fmt.Errorf("unmatched ENDPLUGIN at line %d", i+1)
			}
			inBlock = false
		case isExtraMarker(trimmed):
			marked[trimmed] = true
		}
	}
	if inBlock {
		return "", errors.New("unterminated plugin block")
	}

	unknown := []string{}
	for key := range used {
		if !found[key] {
			unknown = append(unknown, key)
		}
	}

	// A template without its EXTRA markers cannot synthesize the plugin, so a
	// used plugin missing a block would silently disappear. Reject it loudly.
	if len(unknown) > 0 && len(required) == 0 {
		return "", fmt.Errorf("plugin %q has no block in the template", unknown[0])
	}

	// Used plugins without a block must synthesize into the required markers,
	// otherwise they would silently disappear from the generated file.
	if len(unknown) > 0 {
		for m := range required {
			if !marked[m] {
				return "", fmt.Errorf("plugin %q has no block in the template and the template lacks marker %q", unknown[0], m)
			}
		}
	}

	// Assemble the output, dropping unused blocks and injecting the synthesized
	// lines at each EXTRA marker (markers themselves are removed).
	var out []string
	seen := map[string]bool{}
	inBlock = false
	keep := false
	for _, line := range all {
		trimmed := strings.TrimSpace(line)
		switch {
		case strings.HasPrefix(trimmed, "// PLUGIN:"):
			key := strings.TrimSpace(strings.TrimPrefix(trimmed, "// PLUGIN:"))
			inBlock = true
			_, keep = used[key]
		case trimmed == "// ENDPLUGIN":
			inBlock = false
			keep = false
		case isExtraMarker(trimmed):
			if seen[trimmed] {
				continue
			}
			seen[trimmed] = true
			injected, err := emit(trimmed, unknown)
			if err != nil {
				return "", err
			}
			out = append(out, injected...)
		default:
			if !inBlock || keep {
				out = append(out, line)
			}
		}
	}
	return strings.Join(out, "\n"), nil
}

func isExtraMarker(s string) bool {
	switch s {
	case markerImport, markerInit, markerVars, markerMap:
		return true
	}
	return false
}

// synthLines returns the registration lines to inject at an EXTRA marker for
// every unknown plugin. The Xcode lines are derived from the resolved plugin
// name; the Android lines are derived from the plugin's own Plugin.kt (package
// and name properties). Constructors always receive the context argument.
func synthLines(plat platform, used map[string]string, marker string, unknown []string) ([]string, error) {
	var out []string
	for _, key := range unknown {
		name := used[key]
		switch marker {
		case markerImport:
			if plat != platformXcode {
				continue
			}
			out = append(out, "import "+name)
		case markerInit:
			if plat != platformXcode {
				continue
			}
			out = append(out, "  "+name+".Plugin.id: "+name+".Plugin(),")
		case markerVars, markerMap:
			if plat != platformAndroid {
				continue
			}
			pkg, pluginName, err := androidRegistration(filepath.Join("build", "android", "sources", name))
			if err != nil {
				return nil, fmt.Errorf("plugin %q: %w", key, err)
			}
			if marker == markerVars {
				out = append(out, "val "+pluginName+" = "+pkg+".Plugin(context)")
			} else {
				out = append(out, pluginName+".id to "+pluginName+",")
			}
		}
	}
	return out, nil
}

// androidRegistration reads the plugin's own Plugin.kt (already copied into
// build/android/sources/<name>/) and returns its package and the plugin name
// used as the JS registration key.
func androidRegistration(pluginDir string) (pkg, name string, err error) {
	var file string
	err = filepath.Walk(pluginDir, func(p string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() || info.Name() != "Plugin.kt" {
			return nil
		}
		file = p
		if strings.Contains(p, "src/main/java") {
			return filepath.SkipAll
		}
		return nil
	})
	if err != nil {
		return "", "", err
	}
	if file == "" {
		return "", "", fmt.Errorf("no Plugin.kt found under %s", pluginDir)
	}

	data, err := os.ReadFile(file)
	if err != nil {
		return "", "", err
	}

	pkgMatch := regexp.MustCompile(`(?m)^\s*package\s+([\w.]+)\s*$`).FindSubmatch(data)
	if pkgMatch == nil {
		return "", "", fmt.Errorf("no package declaration in %s", file)
	}
	nameMatch := regexp.MustCompile(`(?m)\bval\s+name\s*:\s*String\s+get\(\)\s*=\s*"([^"]+)"`).FindSubmatch(data)
	if nameMatch == nil {
		return "", "", fmt.Errorf("no name property in %s", file)
	}
	return string(pkgMatch[1]), string(nameMatch[1]), nil
}

func lines(s string) []string {
	return strings.Split(s, "\n")
}

// pluginSrcDir resolves a plugin path reference for a platform. When the
// reference does not carry the plugin name (e.g. `@jasonelle` or
// `@jasonelle/xcode`), the config key is used. ok is false when the reference
// targets the other platform and must be skipped.
func pluginSrcDir(plat platform, key, ref string) (src, name string, ok bool, err error) {
	parts := strings.Split(ref, "/")

	isJasonelle := parts[0] == "@jasonelle"
	if parts[0] != "@jasonelle" && parts[0] != "@lib" {
		return "", "", false, fmt.Errorf("unknown plugin path prefix: %s", ref)
	}

	scope := ""
	if len(parts) >= 2 && (parts[1] == "xcode" || parts[1] == "android") {
		scope = parts[1]
		if len(parts) == 3 {
			name = parts[2]
		}
	} else if len(parts) == 2 {
		name = parts[1]
	}

	switch len(parts) {
	case 1, 2, 3:
	default:
		return "", "", false, fmt.Errorf("invalid plugin path: %s", ref)
	}

	if name == "" {
		name = key
	}
	if name == "" {
		return "", "", false, fmt.Errorf("invalid plugin path: %s", ref)
	}

	if scope == "" {
		scope = string(plat)
	} else if scope != string(plat) {
		return "", "", false, nil
	}

	if isJasonelle {
		return filepath.Join("sources", scope, name), name, true, nil
	}
	// @lib plugins live at lib/common/sources/plugins/<name>/<platform>
	return filepath.Join("lib", "common", "sources", "plugins", name, scope), name, true, nil
}

func copyDir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		dest := filepath.Join(dst, rel)
		if info.IsDir() {
			return os.MkdirAll(dest, 0755)
		}
		return copyFile(path, dest)
	})
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()
	_, err = io.Copy(out, in)
	return err
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
