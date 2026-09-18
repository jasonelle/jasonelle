//
//  tools/plugins/main_test.go
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
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestPluginSrcDir(t *testing.T) {
	tests := []struct {
		plat platform
		key  string
		ref  string
		src  string
		name string
		ok   bool
	}{
		{platformXcode, "JLPluginHello", "@jasonelle/JLPluginHello", "sources/xcode/JLPluginHello", "JLPluginHello", true},
		{platformAndroid, "JLPluginHello", "@jasonelle/JLPluginHello", "sources/android/JLPluginHello", "JLPluginHello", true},
		{platformXcode, "JLPluginAppleSignIn", "@jasonelle/xcode/JLPluginAppleSignIn", "sources/xcode/JLPluginAppleSignIn", "JLPluginAppleSignIn", true},
		{platformAndroid, "JLPluginAppleSignIn", "@jasonelle/xcode/JLPluginAppleSignIn", "", "", false},
		{platformXcode, "JLPluginFoo", "@jasonelle/android/JLPluginFoo", "", "", false},
		{platformAndroid, "JLPluginFoo", "@jasonelle/android/JLPluginFoo", "sources/android/JLPluginFoo", "JLPluginFoo", true},
		{platformXcode, "JLPluginCustom", "@lib/JLPluginCustom", "lib/common/sources/plugins/JLPluginCustom/xcode", "JLPluginCustom", true},
		{platformAndroid, "JLPluginCustom", "@lib/JLPluginCustom", "lib/common/sources/plugins/JLPluginCustom/android", "JLPluginCustom", true},
		{platformXcode, "JLPluginCustom", "@lib/xcode/JLPluginCustom", "lib/common/sources/plugins/JLPluginCustom/xcode", "JLPluginCustom", true},
		{platformAndroid, "JLPluginCustom", "@lib/xcode/JLPluginCustom", "", "", false},
		{platformXcode, "JLPluginCustom", "@lib/android/JLPluginCustom", "", "", false},
		{platformAndroid, "JLPluginCustom", "@lib/android/JLPluginCustom", "lib/common/sources/plugins/JLPluginCustom/android", "JLPluginCustom", true},
		// Bare references use the config key as the plugin name
		{platformXcode, "JLPluginCookies", "@jasonelle", "sources/xcode/JLPluginCookies", "JLPluginCookies", true},
		{platformAndroid, "JLPluginCookies", "@jasonelle", "sources/android/JLPluginCookies", "JLPluginCookies", true},
		{platformXcode, "JLPluginAppleSignIn", "@jasonelle/xcode", "sources/xcode/JLPluginAppleSignIn", "JLPluginAppleSignIn", true},
		{platformAndroid, "JLPluginAppleSignIn", "@jasonelle/xcode", "", "", false},
		{platformXcode, "JLPluginCustom", "@lib", "lib/common/sources/plugins/JLPluginCustom/xcode", "JLPluginCustom", true},
		{platformXcode, "JLPluginCustom", "@lib/xcode", "lib/common/sources/plugins/JLPluginCustom/xcode", "JLPluginCustom", true},
		{platformAndroid, "JLPluginCustom", "@lib/xcode", "", "", false},
	}
	for _, tt := range tests {
		src, name, ok, err := pluginSrcDir(tt.plat, tt.key, tt.ref)
		if err != nil {
			t.Errorf("%s %s: unexpected error: %v", tt.plat, tt.ref, err)
			continue
		}
		if ok != tt.ok || src != tt.src || name != tt.name {
			t.Errorf("%s %s: got (%q, %q, %v), want (%q, %q, %v)", tt.plat, tt.ref, src, name, ok, tt.src, tt.name, tt.ok)
		}
	}
}

func TestPluginSrcDirErrors(t *testing.T) {
	for _, ref := range []string{"@other/JLPluginX", "JLPluginX", "@jasonelle/xcode/a/b"} {
		if _, _, _, err := pluginSrcDir(platformXcode, "JLPluginX", ref); err == nil {
			t.Errorf("%s: got nil, want error", ref)
		}
	}
}

func declareConfigs(t *testing.T) (xcodeCfg, androidCfg string) {
	t.Helper()
	xcodeCfg = filepath.Join("build", "xcode", "config", "config.jsonc")
	androidCfg = filepath.Join("build", "android", "config", "config.jsonc")
	mkfile(t, xcodeCfg, `{"plugins": {
		"JLPluginHello": "@jasonelle/JLPluginHello",
		"JLPluginAppleSignIn": "@jasonelle/xcode/JLPluginAppleSignIn",
		"JLPluginAndroidOnly": "@jasonelle/android/JLPluginAndroidOnly",
		"JLPluginCustom": "@lib/JLPluginCustom",
		"JLPluginAuto": "@lib/JLPluginAuto"
	}, "url": "https://jasonelle.com"}`)
	mkfile(t, androidCfg, `{"plugins": {
		"JLPluginHello": "@jasonelle/JLPluginHello",
		"JLPluginAppleSignIn": "@jasonelle/xcode/JLPluginAppleSignIn",
		"JLPluginCustom": "@lib/JLPluginCustom",
		"JLPluginAuto": "@lib/JLPluginAuto"
	}, "url": "https://jasonelle.com"}`)
	return xcodeCfg, androidCfg
}

func declareSources(t *testing.T) {
	t.Helper()
	// Source plugin directories
	mkfile(t, "sources/xcode/JLPluginHello/Plugin.swift", "")
	mkfile(t, "sources/android/JLPluginHello/Plugin.kt", "")
	mkfile(t, "sources/xcode/JLPluginAppleSignIn/Plugin.swift", "")
	mkfile(t, "sources/android/JLPluginAndroidOnly/Plugin.kt", "")
	mkfile(t, "lib/common/sources/plugins/JLPluginCustom/xcode/Plugin.swift", "")
	mkfile(t, "lib/common/sources/plugins/JLPluginCustom/android/Plugin.kt", "")
	// A @lib plugin with no block in the templates, synthesized by the tool
	mkfile(t, "lib/common/sources/plugins/JLPluginAuto/xcode/Plugin.swift", "")
	mkfile(t, "lib/common/sources/plugins/JLPluginAuto/android/src/main/java/com/jasonelle/plugins/auto/Plugin.kt",
		"package com.jasonelle.plugins.auto\n\noverride val name: String get() = \"auto\"\n")
	// Stale destination that must be cleaned
	mkfile(t, "build/xcode/sources/Stale/old.txt", "")
}

const xcodeTemplate = `// header
import JLKernel

// PLUGINS.IMPORT
// PLUGIN:JLPluginHello
import JLPluginHello
// ENDPLUGIN
// PLUGIN:JLPluginAppleSignIn
import JLPluginAppleSignIn
// ENDPLUGIN
// PLUGIN:JLPluginAndroidOnly
import JLPluginAndroidOnly
// ENDPLUGIN
// PLUGIN:JLPluginCustom
import JLPluginCustom
// ENDPLUGIN
// PLUGINS.IMPORT.EXTRA

// PLUGINS.INIT
public let plugins: [String: JLKernel.Plugin] = [
  // PLUGIN:JLPluginHello
  JLPluginHello.Plugin.id: JLPluginHello.Plugin(),
  // ENDPLUGIN
  // PLUGIN:JLPluginAppleSignIn
  JLPluginAppleSignIn.Plugin.id: JLPluginAppleSignIn.Plugin(),
  // ENDPLUGIN
  // PLUGIN:JLPluginAndroidOnly
  JLPluginAndroidOnly.Plugin.id: JLPluginAndroidOnly.Plugin(),
  // ENDPLUGIN
  // PLUGIN:JLPluginCustom
  JLPluginCustom.Plugin.id: JLPluginCustom.Plugin(),
  // ENDPLUGIN
  // PLUGINS.INIT.EXTRA
]
`

const androidTemplate = `package com.jasonelle.application
import com.jasonelle.kernel.Plugin

// PLUGINS.INIT
fun createPlugins(context: Context): Map<String, Plugin> {
  // PLUGIN:JLPluginHello
  val hello = com.jasonelle.plugins.hello.Plugin()
  // ENDPLUGIN
  // PLUGIN:JLPluginAppleSignIn
  val applesignin = com.jasonelle.plugins.applesignin.Plugin(context)
  // ENDPLUGIN
  // PLUGIN:JLPluginCustom
  val custom = com.jasonelle.plugins.custom.Plugin()
  // ENDPLUGIN
  // PLUGINS.INIT.EXTRA.VARS

  return mapOf(
    // PLUGIN:JLPluginHello
    hello.id to hello,
    // ENDPLUGIN
    // PLUGIN:JLPluginAppleSignIn
    applesignin.id to applesignin,
    // ENDPLUGIN
    // PLUGIN:JLPluginCustom
    custom.id to custom,
    // ENDPLUGIN
    // PLUGINS.INIT.EXTRA.MAP
  )
}
`

func declareTemplates(t *testing.T) (xcodeTpl, androidTpl string) {
	t.Helper()
	xcodeTpl = filepath.Join("sources", "xcode", "Application", "Application", "Plugins.swift")
	androidTpl = filepath.Join("sources", "android", "Application", "src", "main", "java", "com", "jasonelle", "application", "Plugins.kt")
	mkfile(t, xcodeTpl, xcodeTemplate)
	mkfile(t, androidTpl, androidTemplate)
	return xcodeTpl, androidTpl
}

func TestRunCopiesPlugins(t *testing.T) {
	dir := t.TempDir()
	old, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(dir); err != nil {
		t.Fatal(err)
	}
	defer os.Chdir(old)

	xcodeCfg, androidCfg := declareConfigs(t)
	declareSources(t)
	xcodeTpl, androidTpl := declareTemplates(t)

	if err := run([]string{
		"--xcode", xcodeCfg,
		"--android", androidCfg,
		"--xcode-template", xcodeTpl,
		"--android-template", androidTpl,
	}); err != nil {
		t.Fatal(err)
	}

	for _, f := range []string{
		"build/xcode/sources/JLPluginHello/Plugin.swift",
		"build/xcode/sources/JLPluginAppleSignIn/Plugin.swift",
		"build/xcode/sources/JLPluginCustom/Plugin.swift",
		"build/xcode/sources/JLPluginAuto/Plugin.swift",
		"build/android/sources/JLPluginHello/Plugin.kt",
		"build/android/sources/JLPluginCustom/Plugin.kt",
		"build/android/sources/JLPluginAuto/src/main/java/com/jasonelle/plugins/auto/Plugin.kt",
	} {
		if _, err := os.Stat(f); err != nil {
			t.Errorf("missing %s: %v", f, err)
		}
	}

	for _, f := range []string{
		"build/xcode/sources/JLPluginAndroidOnly",
		"build/android/sources/JLPluginAppleSignIn",
		"build/xcode/sources/Stale",
	} {
		if _, err := os.Stat(f); err == nil {
			t.Errorf("should not exist %s", f)
		}
	}

	// Generated Plugins.swift reflects only the used Xcode plugins
	xcodeGen := readFile(t, filepath.Join("build", "xcode", "sources", "Application", "Application", "Plugins.swift"))
	for _, want := range []string{"import JLKernel", "public let plugins", "import JLPluginHello", "JLPluginHello.Plugin.id: JLPluginHello.Plugin()", "import JLPluginAppleSignIn", "import JLPluginCustom", "import JLPluginAuto", "JLPluginAuto.Plugin.id: JLPluginAuto.Plugin(),"} {
		if !strings.Contains(xcodeGen, want) {
			t.Errorf("generated Plugins.swift missing %q", want)
		}
	}
	if strings.Contains(xcodeGen, "JLPluginAndroidOnly") {
		t.Errorf("generated Plugins.swift still contains JLPluginAndroidOnly")
	}

	// Generated Plugins.kt reflects only the used Android plugins
	androidGen := readFile(t, filepath.Join("build", "android", "sources", "Application", "src", "main", "java", "com", "jasonelle", "application", "Plugins.kt"))
	for _, want := range []string{"package com.jasonelle.application", "fun createPlugins", "val hello = com.jasonelle.plugins.hello.Plugin()", "hello.id to hello", "val custom = com.jasonelle.plugins.custom.Plugin()", "val auto = com.jasonelle.plugins.auto.Plugin(context)", "auto.id to auto,"} {
		if !strings.Contains(androidGen, want) {
			t.Errorf("generated Plugins.kt missing %q", want)
		}
	}
	if strings.Contains(androidGen, "applesignin") {
		t.Errorf("generated Plugins.kt still contains applesignin")
	}

	// No marker lines leak into the generated files
	for _, gen := range []string{xcodeGen, androidGen} {
		if strings.Contains(gen, "// PLUGIN:") || strings.Contains(gen, "// ENDPLUGIN") || leakExtraMarkers(gen) {
			t.Errorf("generated file contains marker lines:\n%s", gen)
		}
	}

	// Default behavior deletes other-platform entries from the config file
	cfg := readPlugins(t, xcodeCfg)
	if _, ok := cfg["JLPluginAndroidOnly"]; ok {
		t.Errorf("xcode config still contains JLPluginAndroidOnly")
	}
	if cfg["JLPluginAppleSignIn"] != "@jasonelle/xcode/JLPluginAppleSignIn" {
		t.Errorf("xcode config lost JLPluginAppleSignIn")
	}
	cfg = readPlugins(t, androidCfg)
	if _, ok := cfg["JLPluginAppleSignIn"]; ok {
		t.Errorf("android config still contains JLPluginAppleSignIn")
	}
	if cfg["JLPluginHello"] != "@jasonelle/JLPluginHello" {
		t.Errorf("android config lost JLPluginHello")
	}
	// Non-plugin keys are preserved
	cfgAll := readAll(t, androidCfg)
	if cfgAll["url"] != "https://jasonelle.com" {
		t.Errorf("url not preserved: %#v", cfgAll)
	}
}

func TestRunIgnorePlatformKeepsConfig(t *testing.T) {
	dir := t.TempDir()
	old, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(dir); err != nil {
		t.Fatal(err)
	}
	defer os.Chdir(old)

	xcodeCfg, androidCfg := declareConfigs(t)
	declareSources(t)
	xcodeTpl, androidTpl := declareTemplates(t)

	if err := run([]string{
		"--xcode", xcodeCfg,
		"--android", androidCfg,
		"--xcode-template", xcodeTpl,
		"--android-template", androidTpl,
		"--ignore-platform",
	}); err != nil {
		t.Fatal(err)
	}

	// The other-platform entries stay in the config files...
	for _, cfg := range []string{xcodeCfg, androidCfg} {
		cfgAll := readAll(t, cfg)
		if _, ok := cfgAll["plugins"].(map[string]any)["JLPluginAppleSignIn"]; !ok {
			t.Errorf("%s lost JLPluginAppleSignIn with --ignore-platform", cfg)
		}
	}
	// ...but are still skipped at copy time
	if _, err := os.Stat("build/android/sources/JLPluginAppleSignIn"); err == nil {
		t.Errorf("android copied other-platform plugin with --ignore-platform")
	}
	// Generation still runs and reflects the used plugins
	xcodeGen := readFile(t, filepath.Join("build", "xcode", "sources", "Application", "Application", "Plugins.swift"))
	if !strings.Contains(xcodeGen, "import JLPluginAppleSignIn") {
		t.Errorf("ignore mode should keep used plugins in Plugins.swift")
	}
	if strings.Contains(xcodeGen, "JLPluginAndroidOnly") {
		t.Errorf("ignore mode must not add other-platform plugins to Plugins.swift")
	}
}

func TestFilterMarkedBlocks(t *testing.T) {
	tpl := "// static\n// PLUGIN:A\nimport A\n// ENDPLUGIN\n// PLUGIN:B\nimport B\n// ENDPLUGIN\ntail"

	// required set even though the template has no EXTRA markers and no
	// unknown plugins, so nothing is emitted.
	got, err := filterMarkedBlocks(tpl, map[string]string{"A": "A"}, map[string]bool{markerImport: true, markerInit: true}, func(string, []string) ([]string, error) { return nil, nil })
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(got, "import A") || strings.Contains(got, "import B") {
		t.Errorf("got:\n%s", got)
	}
	if !strings.Contains(got, "// static") || !strings.Contains(got, "tail") {
		t.Errorf("static parts lost:\n%s", got)
	}
	if strings.Contains(got, "// PLUGIN:") || strings.Contains(got, "// ENDPLUGIN") || leakExtraMarkers(got) {
		t.Errorf("markers leaked:\n%s", got)
	}

	for _, bad := range []struct {
		tpl      string
		used     map[string]string
		required map[string]bool
		want     string
	}{
		{"// PLUGIN:A\nimport A", map[string]string{"A": "A"}, nil, "unterminated"},
		{"// ENDPLUGIN\nimport A", map[string]string{}, nil, "unmatched"},
		{"// PLUGIN:A\n// PLUGIN:B\n// ENDPLUGIN\n// ENDPLUGIN", map[string]string{}, nil, "nested"},
		{"// PLUGIN:A\nimport A\n// ENDPLUGIN", map[string]string{"A": "A", "MISSING": "MISSING"}, nil, "no block"},
		{"// PLUGIN:A\nimport A\n// ENDPLUGIN\n// PLUGINS.IMPORT.EXTRA", map[string]string{"A": "A", "MISSING": "MISSING"}, map[string]bool{markerImport: true, markerInit: true}, "lacks marker"},
	} {
		if _, err := filterMarkedBlocks(bad.tpl, bad.used, bad.required, func(string, []string) ([]string, error) { return nil, nil }); err == nil || !strings.Contains(err.Error(), bad.want) {
			t.Errorf("template %q: got %v, want error containing %q", bad.tpl, err, bad.want)
		}
	}
}

func TestFilterMarkedBlocksSynthesizes(t *testing.T) {
	tpl := "// PLUGIN:A\nimport A\n// ENDPLUGIN\n// PLUGINS.IMPORT.EXTRA\n// PLUGINS.INIT\nx\n// PLUGIN:A\nA.id: A(),\n// ENDPLUGIN\n// PLUGINS.INIT.EXTRA\ny"

	got, err := filterMarkedBlocks(tpl, map[string]string{"A": "A", "B": "B"}, map[string]bool{markerImport: true, markerInit: true}, func(marker string, unknown []string) ([]string, error) {
		if marker == markerImport {
			return []string{"import B"}, nil
		}
		if marker == markerInit {
			return []string{"B.id: B(),"}, nil
		}
		return nil, nil
	})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"import A", "import B", "A.id: A(),", "B.id: B(),", "x", "y"} {
		if !strings.Contains(got, want) {
			t.Errorf("got missing %q:\n%s", want, got)
		}
	}
	if strings.Contains(got, "// PLUGIN:") || leakExtraMarkers(got) {
		t.Errorf("markers leaked:\n%s", got)
	}
}

func leakExtraMarkers(s string) bool {
	return strings.Contains(s, markerImport) || strings.Contains(s, markerInit) ||
		strings.Contains(s, markerVars) || strings.Contains(s, markerMap)
}

func TestSynthLinesAndroid(t *testing.T) {
	mkfile(t, "build/android/sources/JLPluginAuto/src/main/java/com/jasonelle/plugins/auto/Plugin.kt",
		"package com.jasonelle.plugins.auto\n\noverride val name: String get() = \"auto\"\n")
	used := map[string]string{"JLPluginAuto": "JLPluginAuto"}
	unknown := []string{"JLPluginAuto"}

	vars, err := synthLines(platformAndroid, used, markerVars, unknown)
	if err != nil {
		t.Fatal(err)
	}
	if len(vars) != 1 || vars[0] != "val auto = com.jasonelle.plugins.auto.Plugin(context)" {
		t.Errorf("vars = %#v", vars)
	}

	entries, err := synthLines(platformAndroid, used, markerMap, unknown)
	if err != nil {
		t.Fatal(err)
	}
	if len(entries) != 1 || entries[0] != "auto.id to auto," {
		t.Errorf("entries = %#v", entries)
	}
}

func TestSynthLinesXcode(t *testing.T) {
	used := map[string]string{"JLPluginAuto": "JLPluginAuto"}
	unknown := []string{"JLPluginAuto"}

	got, err := synthLines(platformXcode, used, markerImport, unknown)
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 1 || got[0] != "import JLPluginAuto" {
		t.Errorf("import = %#v", got)
	}

	got, err = synthLines(platformXcode, used, markerInit, unknown)
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 1 || got[0] != "  JLPluginAuto.Plugin.id: JLPluginAuto.Plugin()," {
		t.Errorf("init = %#v", got)
	}
}

func TestAndroidRegistration(t *testing.T) {
	pkg, name, err := androidRegistration(filepath.Join("build", "android", "sources", "JLPluginAuto"))
	if err != nil {
		t.Fatal(err)
	}
	if pkg != "com.jasonelle.plugins.auto" || name != "auto" {
		t.Errorf("got %q / %q", pkg, name)
	}

	if _, _, err := androidRegistration("does/not/exist"); err == nil {
		t.Errorf("got nil, want error for missing plugin dir")
	}
}

func readFile(t *testing.T, path string) string {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	return string(data)
}

func readAll(t *testing.T, path string) map[string]any {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	var cfg map[string]any
	if err := json.Unmarshal(data, &cfg); err != nil {
		t.Fatal(err)
	}
	return cfg
}

func readPlugins(t *testing.T, path string) map[string]string {
	t.Helper()
	cfg := readAll(t, path)
	raw, _ := cfg["plugins"].(map[string]any)
	out := map[string]string{}
	for k, v := range raw {
		out[k] = v.(string)
	}
	return out
}

func TestRunErrors(t *testing.T) {
	if err := run(nil); err == nil || !strings.Contains(err.Error(), "--xcode") {
		t.Fatalf("got %v, want missing --xcode/--android error", err)
	}

	dir := t.TempDir()
	old, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(dir); err != nil {
		t.Fatal(err)
	}
	defer os.Chdir(old)

	mkfile(t, "build/xcode/config/config.jsonc", `{"plugins": {
		"Bad": "@other/JLPluginX"
	}}`)
	mkfile(t, "build/android/config/config.jsonc", `{"plugins": {}}`)
	if err := run([]string{
		"--xcode", "build/xcode/config/config.jsonc",
		"--android", "build/android/config/config.jsonc",
	}); err == nil || !strings.Contains(err.Error(), "unknown plugin path prefix") {
		t.Fatalf("got %v, want unknown prefix error", err)
	}
}

func mkfile(t *testing.T, path, content string) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatal(err)
	}
}
