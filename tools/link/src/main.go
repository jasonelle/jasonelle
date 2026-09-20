//
//  tools/link/main.go
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-20
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
	"crypto/md5"
	"encoding/hex"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("link", flag.ContinueOnError)
	xcodeSources := fs.String("xcode-sources", "build/xcode/sources", "path to the assembled Xcode source tree")
	androidSources := fs.String("android-sources", "build/android/sources", "path to the assembled Android source tree")
	if err := fs.Parse(args); err != nil {
		return err
	}
	if err := linkXcode(*xcodeSources); err != nil {
		return err
	}
	if err := copyAppArtifacts(*xcodeSources, map[string]string{
		"config/config.jsonc": filepath.Join("Application", "Application", "config.jsonc"),
		"scripts/webview.js":  filepath.Join("Application", "Application", "webview.js"),
	}); err != nil {
		return err
	}
	if err := linkAndroid(*androidSources); err != nil {
		return err
	}
	if err := copyAppArtifacts(*androidSources, map[string]string{
		"config/config.jsonc": filepath.Join("Application", "src", "main", "assets", "config.jsonc"),
		"scripts/webview.js":  filepath.Join("Application", "src", "main", "assets", "webview.js"),
	}); err != nil {
		return err
	}
	return nil
}

// linkXcode syncs the plugin project references in the workspace and the
// plugin framework dependencies in the Application project with the plugins
// currently present in the assembled Xcode source tree. It must run after the
// core tool, which reseeds those files from the stock sources.
func linkXcode(sources string) error {
	plugins, err := scanPlugins(sources, true)
	if err != nil {
		return err
	}
	ws := filepath.Join(sources, "Jasonelle.xcworkspace", "contents.xcworkspacedata")
	if err := rewriteFile(ws, func(content string) (string, error) {
		return syncWorkspace(content, plugins), nil
	}); err != nil {
		return err
	}
	pbx := filepath.Join(sources, "Application", "Application.xcodeproj", "project.pbxproj")
	return rewriteFile(pbx, func(content string) (string, error) {
		return syncPbxproj(content, plugins)
	})
}

// linkAndroid syncs the plugin module includes in settings.gradle.kts and the
// plugin project dependencies in the Application project with the plugins
// currently present in the assembled Android source tree.
func linkAndroid(sources string) error {
	plugins, err := scanPlugins(sources, false)
	if err != nil {
		return err
	}
	if err := rewriteFile(filepath.Join(sources, "settings.gradle.kts"), func(content string) (string, error) {
		return syncSettings(content, plugins)
	}); err != nil {
		return err
	}
	return rewriteFile(filepath.Join(sources, "Application", "build.gradle.kts"), func(content string) (string, error) {
		return syncAppGradle(content, plugins)
	})
}

// rewriteFile applies edit to the file contents and writes it back when it
// changed, so untouched files keep their original bytes.
func rewriteFile(path string, edit func(string) (string, error)) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	out, err := edit(string(data))
	if err != nil {
		return err
	}
	if out == string(data) {
		return nil
	}
	return os.WriteFile(path, []byte(out), 0644)
}

// copyAppArtifacts copies the built config and bundled scripts from the
// build/<platform>/ dir into the assembled Application tree, replacing the
// stock placeholders the core tool copied. The inputs are derived as siblings
// of sources (build/<platform>/config and build/<platform>/scripts).
func copyAppArtifacts(sources string, dests map[string]string) error {
	for _, artifact := range []string{"config/config.jsonc", "scripts/webview.js"} {
		if err := copyArtifact(sources, artifact, dests[artifact]); err != nil {
			return err
		}
	}
	return nil
}

// copyArtifact copies the built file at <build>/<input> into
// <sources>/<dest>, failing when the input is missing and skipping the write
// when the destination already matches, so reruns are byte-stable no-ops.
func copyArtifact(sources, input, dest string) error {
	src := filepath.Join(filepath.Dir(sources), input)
	data, err := os.ReadFile(src)
	if err != nil {
		return err
	}
	dst := filepath.Join(sources, dest)
	if cur, err := os.ReadFile(dst); err == nil && string(cur) == string(data) {
		return nil
	}
	if err := os.MkdirAll(filepath.Dir(dst), 0755); err != nil {
		return err
	}
	return os.WriteFile(dst, data, 0644)
}

// scanPlugins returns the sorted names of the plugin directories at the top
// level of an assembled source tree. A plugin is any directory starting with
// JLPlugin; for Xcode it must contain <name>.xcodeproj.
// ponytail: JLPlugin name prefix convention; revisit if a plugin ever breaks it.
func scanPlugins(sources string, xcode bool) ([]string, error) {
	entries, err := os.ReadDir(sources)
	if err != nil {
		return nil, err
	}
	plugins := []string{}
	for _, e := range entries {
		if !e.IsDir() || !strings.HasPrefix(e.Name(), "JLPlugin") {
			continue
		}
		name := e.Name()
		if xcode {
			proj := filepath.Join(sources, name, name+".xcodeproj")
			if _, err := os.Stat(proj); err != nil {
				return nil, fmt.Errorf("%s: %w", proj, err)
			}
		}
		plugins = append(plugins, name)
	}
	sort.Strings(plugins)
	return plugins, nil
}

//
// Xcode workspace
//

var wsPluginRe = regexp.MustCompile(`location = "group:(JLPlugin[^/]+)/`)

// syncWorkspace keeps every FileRef block verbatim except the JLPlugin*
// ones, which are replaced by the current set in sorted order.
func syncWorkspace(content string, plugins []string) string {
	blocks := parseWorkspace(content)

	start := -1
	for i, b := range blocks {
		if b.isPlugin {
			start = i
			break
		}
	}
	if start == -1 {
		for i, b := range blocks {
			if strings.Contains(b.text, `location = "container:`) || strings.TrimSpace(b.text) == "</Workspace>" {
				start = i
				break
			}
		}
	}

	var out []string
	for i := 0; i < len(blocks); i++ {
		if i == start {
			out = append(out, pluginRefBlocks(plugins)...)
			for i < len(blocks) && blocks[i].isPlugin {
				i++
			}
		}
		if i < len(blocks) {
			out = append(out, blocks[i].text)
		}
	}
	return strings.Join(out, "\n")
}

type wsBlock struct {
	isPlugin bool
	text     string
}

func parseWorkspace(content string) []wsBlock {
	lines := strings.Split(content, "\n")
	blocks := []wsBlock{}
	for i := 0; i < len(lines); i++ {
		if strings.TrimSpace(lines[i]) != "<FileRef" {
			blocks = append(blocks, wsBlock{text: lines[i]})
			continue
		}
		block := []string{lines[i]}
		for j := i + 1; j < len(lines) && j < i+3; j++ {
			block = append(block, lines[j])
		}
		text := strings.Join(block, "\n")
		blocks = append(blocks, wsBlock{isPlugin: wsPluginRe.MatchString(text), text: text})
		i += 2
	}
	return blocks
}

func pluginRefBlocks(plugins []string) []string {
	out := []string{}
	for _, p := range plugins {
		out = append(out, fmt.Sprintf(`   <FileRef
      location = "group:%s/%s.xcodeproj">
   </FileRef>`, p, p))
	}
	return out
}

//
// Xcode Application project
//

var pluginJobRe = regexp.MustCompile(`/\* JLPlugin[A-Za-z0-9_]*\.framework( in Frameworks)? \*/`)

// buildFileRe captures the framework file reference id of a PBXBuildFile entry,
// used by the tests to verify cross-references stay intact.
var buildFileRe = regexp.MustCompile(`\{isa = PBXBuildFile; fileRef = ([0-9A-F]{24}) /* `)

// syncPbxproj removes every JLPlugin* framework reference (PBXBuildFile,
// PBXFileReference, Frameworks build phase entry and Frameworks group child)
// and re-inserts them for the current plugins with deterministic object IDs,
// so a removed plugin disappears and a rerun is byte-stable.
func syncPbxproj(content string, plugins []string) (string, error) {
	lines := strings.Split(content, "\n")

	kept := []string{}
	for _, ln := range lines {
		if pluginJobRe.MatchString(ln) {
			continue
		}
		kept = append(kept, ln)
	}

	inserts := map[int][]string{}
	find := func(trimmed string) (int, error) {
		for i, ln := range kept {
			if strings.TrimSpace(ln) == trimmed {
				return i, nil
			}
		}
		return -1, fmt.Errorf("%s not found in project.pbxproj", trimmed)
	}

	var buildLines, refLines, phaseLines, groupLines []string
	for _, p := range plugins {
		buildID, fileRefID := ids(p)
		buildLines = append(buildLines, fmt.Sprintf("\t\t%s /* %s.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = %s /* %s.framework */; };", buildID, p, fileRefID, p))
		refLines = append(refLines, fmt.Sprintf("\t\t%s /* %s.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = %s.framework; sourceTree = BUILT_PRODUCTS_DIR; };", fileRefID, p, p))
		phaseLines = append(phaseLines, fmt.Sprintf("\t\t\t\t%s /* %s.framework in Frameworks */,", buildID, p))
		groupLines = append(groupLines, fmt.Sprintf("\t\t\t\t%s /* %s.framework */,", fileRefID, p))
	}

	if i, err := find("/* End PBXBuildFile section */"); err != nil {
		return "", err
	} else {
		inserts[i] = buildLines
	}
	if i, err := find("/* End PBXFileReference section */"); err != nil {
		return "", err
	} else {
		inserts[i] = refLines
	}

	phaseClose, err := frameworkPhaseClose(kept)
	if err != nil {
		return "", err
	}
	inserts[phaseClose] = phaseLines

	groupClose, err := frameworkGroupClose(kept)
	if err != nil {
		return "", err
	}
	inserts[groupClose] = groupLines

	out := []string{}
	for i, ln := range kept {
		if injected, ok := inserts[i]; ok {
			out = append(out, injected...)
		}
		out = append(out, ln)
	}
	return strings.Join(out, "\n"), nil
}

// frameworkPhaseClose returns the index of the ");" closing the files list of
// the Frameworks build phase that contains framework references (the
// Application target; the test targets ship an empty list).
func frameworkPhaseClose(lines []string) (int, error) {
	for i := 0; i < len(lines); i++ {
		if strings.TrimSpace(lines[i]) != "isa = PBXFrameworksBuildPhase;" {
			continue
		}
		hasFramework, closeIdx := false, -1
		for j := i + 1; j < len(lines); j++ {
			if strings.TrimSpace(lines[j]) == "files = (" {
				for k := j + 1; k < len(lines); k++ {
					if strings.TrimSpace(lines[k]) == ");" {
						closeIdx = k
						break
					}
					if strings.Contains(lines[k], ".framework") {
						hasFramework = true
					}
				}
			}
			if closeIdx != -1 {
				break
			}
		}
		if hasFramework {
			return closeIdx, nil
		}
	}
	return -1, errors.New("Frameworks build phase with framework entries not found in project.pbxproj")
}

// frameworkGroupClose returns the index of the ");" closing the children list
// of the "Frameworks" group. The children list sits immediately above the
// group's name line in Xcode output.
func frameworkGroupClose(lines []string) (int, error) {
	for i := 0; i < len(lines); i++ {
		if strings.TrimSpace(lines[i]) != "name = Frameworks;" {
			continue
		}
		for j := i - 1; j >= 0; j-- {
			if strings.TrimSpace(lines[j]) == ");" {
				return j, nil
			}
		}
		return -1, errors.New("Frameworks group not found in project.pbxproj")
	}
	return -1, errors.New("Frameworks group not found in project.pbxproj")
}

// ids returns deterministic 24-hex-digit object IDs for a plugin's framework
// file reference and its build file, so reruns are byte-stable.
func ids(name string) (buildFile, fileRef string) {
	return id("buildfile:" + name), id("fileref:" + name)
}

func id(seed string) string {
	sum := md5.Sum([]byte(seed))
	return strings.ToUpper(hex.EncodeToString(sum[:12]))
}

//
// Android
//

var includeRe = regexp.MustCompile(`^\s*include\(":[^"]+"\)\s*$`)
var projectDepRe = regexp.MustCompile(`^\s*implementation\(project\(":[^"]+"\)\)\s*$`)

// syncSettings replaces the module includes with Application, JLKernel and the
// current plugins. Everything else is kept verbatim.
func syncSettings(content string, plugins []string) (string, error) {
	lines := strings.Split(content, "\n")
	kept := []string{}
	for _, ln := range lines {
		if includeRe.MatchString(ln) {
			continue
		}
		kept = append(kept, ln)
	}

	desired := []string{`include(":Application")`, `include(":JLKernel")`}
	for _, p := range plugins {
		desired = append(desired, fmt.Sprintf(`include(":%s")`, p))
	}

	anchor := len(kept)
	for i, ln := range kept {
		if strings.TrimSpace(ln) == `rootProject.name = "Jasonelle"` {
			anchor = i + 1
			break
		}
	}
	return splice(kept, anchor, desired), nil
}

// syncAppGradle replaces the project dependencies in the dependencies block
// with JLKernel and the current plugins.
func syncAppGradle(content string, plugins []string) (string, error) {
	lines := strings.Split(content, "\n")
	kept := []string{}
	for _, ln := range lines {
		if projectDepRe.MatchString(ln) {
			continue
		}
		kept = append(kept, ln)
	}

	anchor := -1
	for i, ln := range kept {
		if strings.TrimSpace(ln) == "dependencies {" {
			anchor = i + 1
			break
		}
	}
	if anchor == -1 {
		return "", errors.New(`"dependencies {" block not found in Application/build.gradle.kts`)
	}

	desired := []string{`  implementation(project(":JLKernel"))`}
	for _, p := range plugins {
		desired = append(desired, fmt.Sprintf(`  implementation(project(":%s"))`, p))
	}
	return splice(kept, anchor, desired), nil
}

// splice inserts lines at anchor (before it) into base and joins with newlines.
func splice(base []string, anchor int, lines []string) string {
	out := make([]string, 0, len(base)+len(lines))
	out = append(out, base[:anchor]...)
	out = append(out, lines...)
	out = append(out, base[anchor:]...)
	return strings.Join(out, "\n")
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
