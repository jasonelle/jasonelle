//
//  tools/link/main_test.go
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
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestScanPlugins(t *testing.T) {
	dir := t.TempDir()
	for _, d := range []string{
		"Application", "JLKernel", "Jasonelle.xcworkspace",
		"JLPluginHello/JLPluginHello.xcodeproj",
		"JLPluginDevice/JLPluginDevice.xcodeproj",
	} {
		mkdir(t, filepath.Join(dir, d))
	}
	mkfile(t, filepath.Join(dir, "README.md"), "")

	got, err := scanPlugins(dir, true)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Join(got, ",") != "JLPluginDevice,JLPluginHello" {
		t.Errorf("got %#v", got)
	}

	// Android mode does not require an .xcodeproj
	mkdir(t, filepath.Join(dir, "JLPluginCustom"))
	got, err = scanPlugins(dir, false)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Join(got, ",") != "JLPluginCustom,JLPluginDevice,JLPluginHello" {
		t.Errorf("got %#v", got)
	}

	// Xcode mode fails loudly on a JLPlugin dir without a project
	if _, err := scanPlugins(dir, true); err == nil || !strings.Contains(err.Error(), "JLPluginCustom.xcodeproj") {
		t.Errorf("got %v, want missing xcodeproj error", err)
	}
}

func TestScanPluginsMissingDir(t *testing.T) {
	if _, err := scanPlugins(filepath.Join(t.TempDir(), "nope"), true); err == nil {
		t.Error("got nil, want error")
	}
}

const workspaceFixture = `<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "group:JLPluginAppleSignIn/JLPluginAppleSignIn.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:JLPluginHello/JLPluginHello.xcodeproj">
   </FileRef>
   <FileRef
      location = "group:JLKernel/JLKernel.xcodeproj">
   </FileRef>
   <FileRef
      location = "container:Application/Application.xcodeproj">
   </FileRef>
</Workspace>
`

func TestSyncWorkspace(t *testing.T) {
	got := syncWorkspace(workspaceFixture, []string{"JLPluginHello"})
	for _, want := range []string{
		`location = "group:JLPluginHello/JLPluginHello.xcodeproj"`,
		`location = "group:JLKernel/JLKernel.xcodeproj"`,
		`location = "container:Application/Application.xcodeproj"`,
		`<?xml version="1.0" encoding="UTF-8"?>`,
	} {
		if !strings.Contains(got, want) {
			t.Errorf("missing %q in:\n%s", want, got)
		}
	}
	if strings.Contains(got, "JLPluginAppleSignIn") {
		t.Errorf("stale plugin kept:\n%s", got)
	}
	// Reruns are byte-stable
	if again := syncWorkspace(got, []string{"JLPluginHello"}); again != got {
		t.Errorf("rerun not stable:\n%s", again)
	}
}

func TestSyncWorkspaceAddsPlugins(t *testing.T) {
	core := `<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "group:JLKernel/JLKernel.xcodeproj">
   </FileRef>
   <FileRef
      location = "container:Application/Application.xcodeproj">
   </FileRef>
</Workspace>
`
	got := syncWorkspace(core, []string{"JLPluginHello", "JLPluginDevice"})
	for _, want := range []string{
		`location = "group:JLPluginDevice/JLPluginDevice.xcodeproj"`,
		`location = "group:JLPluginHello/JLPluginHello.xcodeproj"`,
	} {
		if !strings.Contains(got, want) {
			t.Errorf("missing %q in:\n%s", want, got)
		}
	}
}

const pbxFixture = `// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 77;
	objects = {

/* Begin PBXBuildFile section */
		9A57A4D1303646AA00C5F416 /* JLKernel.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 9A57A4D0303646AA00C5F416 /* JLKernel.framework */; };
		9A57A4D3303646AD00C5F416 /* JLPluginHello.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 9A57A4D2303646AD00C5F416 /* JLPluginHello.framework */; };
		9A57A4D4303646AA00C5F416 /* JLPluginDevice.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 9A57A4D5303646AA00C5F416 /* JLPluginDevice.framework */; };
		9BB3C1623050100000000001 /* JLPluginAppleSignIn.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 9BB3C1613050100000000001 /* JLPluginAppleSignIn.framework */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		9A57A4D0303646AA00C5F416 /* JLKernel.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = JLKernel.framework; sourceTree = BUILT_PRODUCTS_DIR; };
		9A57A4D2303646AD00C5F416 /* JLPluginHello.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = JLPluginHello.framework; sourceTree = BUILT_PRODUCTS_DIR; };
		9A57A4D5303646AA00C5F416 /* JLPluginDevice.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = JLPluginDevice.framework; sourceTree = BUILT_PRODUCTS_DIR; };
		9BB3C1613050100000000001 /* JLPluginAppleSignIn.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; path = JLPluginAppleSignIn.framework; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		9A57A4423036454600C5F416 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				9BB3C1623050100000000001 /* JLPluginAppleSignIn.framework in Frameworks */,
				9A57A4D3303646AD00C5F416 /* JLPluginHello.framework in Frameworks */,
				9A57A4D1303646AA00C5F416 /* JLKernel.framework in Frameworks */,
				9A57A4D4303646AA00C5F416 /* JLPluginDevice.framework in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		9A57A4CF303646AA00C5F416 /* Frameworks */ = {
			isa = PBXGroup;
			children = (
				9BB3C1613050100000000001 /* JLPluginAppleSignIn.framework */,
				9A57A4D2303646AD00C5F416 /* JLPluginHello.framework */,
				9A57A4D0303646AA00C5F416 /* JLKernel.framework */,
				9A57A4D5303646AA00C5F416 /* JLPluginDevice.framework */,
			);
			name = Frameworks;
			sourceTree = "<group>";
		};
/* End PBXGroup section */
	};
	rootObject = 9A57A43D3036454600C5F416 /* Project object */;
}
`

func TestSyncPbxproj(t *testing.T) {
	got, err := syncPbxproj(pbxFixture, []string{"JLPluginHello", "JLPluginDevice"})
	if err != nil {
		t.Fatal(err)
	}

	has := []string{
		"JLPluginHello.framework in Frameworks",
		"JLPluginDevice.framework in Frameworks",
		`path = JLPluginHello.framework; sourceTree = BUILT_PRODUCTS_DIR`,
		`path = JLPluginDevice.framework; sourceTree = BUILT_PRODUCTS_DIR`,
		`JLKernel.framework in Frameworks`,
		`/* End PBXBuildFile section */`,
	}
	for _, want := range has {
		if !strings.Contains(got, want) {
			t.Errorf("missing %q in:\n%s", want, got)
		}
	}
	if strings.Contains(got, "JLPluginAppleSignIn") {
		t.Errorf("stale plugin kept:\n%s", got)
	}
	// The plugin file reference must match its build file back-reference
	if !buildRefsMatch(got) {
		t.Errorf("plugin build file does not reference its file ref:\n%s", got)
	}
	// Reruns are byte-stable
	if again, err := syncPbxproj(got, []string{"JLPluginHello", "JLPluginDevice"}); err != nil || again != got {
		t.Errorf("rerun not stable (err=%v):\n%s", err, again)
	}
}

func TestSyncPbxprojRemovesAll(t *testing.T) {
	got, err := syncPbxproj(pbxFixture, nil)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(got, "JLPlugin") {
		t.Errorf("plugins still linked:\n%s", got)
	}
	if !strings.Contains(got, "JLKernel.framework in Frameworks") {
		t.Errorf("JLKernel lost:\n%s", got)
	}
}

func TestSyncSettings(t *testing.T) {
	in := `rootProject.name = "Jasonelle"

include(":Application")
include(":JLKernel")
include(":JLPluginDevice")
`
	got, err := syncSettings(in, []string{"JLPluginHello", "JLPluginAppleSignIn"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{
		`rootProject.name = "Jasonelle"`,
		`include(":Application")`,
		`include(":JLKernel")`,
		`include(":JLPluginAppleSignIn")`,
		`include(":JLPluginHello")`,
	} {
		if !strings.Contains(got, want) {
			t.Errorf("missing %q in:\n%s", want, got)
		}
	}
	if strings.Contains(got, "JLPluginDevice") {
		t.Errorf("stale include kept:\n%s", got)
	}
	if again, err := syncSettings(got, []string{"JLPluginHello", "JLPluginAppleSignIn"}); err != nil || again != got {
		t.Errorf("rerun not stable (err=%v):\n%s", err, again)
	}
}

func TestSyncAppGradle(t *testing.T) {
	in := `dependencies {
  implementation(project(":JLKernel"))
  implementation(project(":JLPluginDevice"))

  implementation("androidx.core:core-ktx:1.13.1")
}
`
	got, err := syncAppGradle(in, []string{"JLPluginHello"})
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{
		`  implementation(project(":JLKernel"))`,
		`  implementation(project(":JLPluginHello"))`,
		`  implementation("androidx.core:core-ktx:1.13.1")`,
	} {
		if !strings.Contains(got, want) {
			t.Errorf("missing %q in:\n%s", want, got)
		}
	}
	if strings.Contains(got, "JLPluginDevice") {
		t.Errorf("stale dep kept:\n%s", got)
	}
	if again, err := syncAppGradle(got, []string{"JLPluginHello"}); err != nil || again != got {
		t.Errorf("rerun not stable (err=%v):\n%s", err, again)
	}
}

func TestSyncAppGradleNoBlock(t *testing.T) {
	if _, err := syncAppGradle("plugins {\n}", nil); err == nil {
		t.Error("got nil, want missing dependencies block error")
	}
}

func TestIDS(t *testing.T) {
	a1, a2 := ids("JLPluginHello")
	b1, b2 := ids("JLPluginDevice")
	if a1 == b1 || a1 == a2 || a2 == b2 {
		t.Errorf("ids not distinct: %s %s %s %s", a1, a2, b1, b2)
	}
	if id("x") != id("x") || len(a1) != 24 {
		t.Errorf("ids not deterministic or not 24 hex: %s", a1)
	}
}

func TestRunIntegration(t *testing.T) {
	xcode := t.TempDir()
	mkdir(t, filepath.Join(xcode, "JLPluginHello/JLPluginHello.xcodeproj"))
	mkdir(t, filepath.Join(xcode, "JLPluginDevice/JLPluginDevice.xcodeproj"))
	mkfile(t, filepath.Join(xcode, "Jasonelle.xcworkspace", "contents.xcworkspacedata"), workspaceFixture)
	mkfile(t, filepath.Join(xcode, "Application", "Application.xcodeproj", "project.pbxproj"), pbxFixture)

	android := t.TempDir()
	mkdir(t, filepath.Join(android, "JLPluginHello"))
	mkdir(t, filepath.Join(android, "JLPluginAppleSignIn"))
	mkfile(t, filepath.Join(android, "settings.gradle.kts"), `rootProject.name = "Jasonelle"

include(":Application")
include(":JLKernel")
include(":JLPluginDevice")
`)
	mkfile(t, filepath.Join(android, "Application", "build.gradle.kts"), `dependencies {
  implementation(project(":JLKernel"))
  implementation(project(":JLPluginDevice"))
}
`)

	if err := run([]string{"--xcode-sources", xcode, "--android-sources", android}); err != nil {
		t.Fatal(err)
	}

	ws := read(t, filepath.Join(xcode, "Jasonelle.xcworkspace", "contents.xcworkspacedata"))
	if !strings.Contains(ws, "JLPluginHello.xcodeproj") || !strings.Contains(ws, "JLPluginDevice.xcodeproj") {
		t.Errorf("workspace missing linked plugins:\n%s", ws)
	}
	if strings.Contains(ws, "JLPluginAppleSignIn") {
		t.Errorf("workspace kept stale plugin:\n%s", ws)
	}

	pbx := read(t, filepath.Join(xcode, "Application", "Application.xcodeproj", "project.pbxproj"))
	if strings.Contains(pbx, "JLPluginAppleSignIn") || !strings.Contains(pbx, "JLPluginHello.framework in Frameworks") {
		t.Errorf("pbxproj not synced:\n%s", pbx)
	}

	settings := read(t, filepath.Join(android, "settings.gradle.kts"))
	for _, want := range []string{`include(":JLPluginHello")`, `include(":JLPluginAppleSignIn")`} {
		if !strings.Contains(settings, want) {
			t.Errorf("settings missing %q:\n%s", want, settings)
		}
	}
	if strings.Contains(settings, "JLPluginDevice") {
		t.Errorf("settings kept stale include:\n%s", settings)
	}

	app := read(t, filepath.Join(android, "Application", "build.gradle.kts"))
	if !strings.Contains(app, `implementation(project(":JLPluginHello"))`) || strings.Contains(app, "JLPluginDevice") {
		t.Errorf("Application not synced:\n%s", app)
	}

	// A second run must leave every file unchanged
	snapshot := []string{ws, pbx, settings, app}
	if err := run([]string{"--xcode-sources", xcode, "--android-sources", android}); err != nil {
		t.Fatal(err)
	}
	current := []string{
		read(t, filepath.Join(xcode, "Jasonelle.xcworkspace", "contents.xcworkspacedata")),
		read(t, filepath.Join(xcode, "Application", "Application.xcodeproj", "project.pbxproj")),
		read(t, filepath.Join(android, "settings.gradle.kts")),
		read(t, filepath.Join(android, "Application", "build.gradle.kts")),
	}
	for i := range snapshot {
		if snapshot[i] != current[i] {
			t.Errorf("rerun changed output #%d", i)
		}
	}
}

func TestRunBrokenPluginTree(t *testing.T) {
	xcode := t.TempDir()
	mkdir(t, filepath.Join(xcode, "JLPluginBroken"))
	if err := linkXcode(xcode); err == nil || !strings.Contains(err.Error(), "JLPluginBroken.xcodeproj") {
		t.Errorf("got %v, want missing xcodeproj error", err)
	}
}

// buildRefsMatch checks that each plugin PBXBuildFile line references its own
// PBXFileReference id.
func buildRefsMatch(pbx string) bool {
	for _, m := range buildFileRe.FindAllStringSubmatch(pbx, -1) {
		if !strings.Contains(pbx, m[1]) {
			return false
		}
	}
	return true
}

func read(t *testing.T, path string) string {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	return string(data)
}

func mkdir(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(path, 0755); err != nil {
		t.Fatal(err)
	}
}

func mkfile(t *testing.T, path, content string) {
	t.Helper()
	mkdir(t, filepath.Dir(path))
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatal(err)
	}
}
