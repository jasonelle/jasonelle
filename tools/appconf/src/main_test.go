//
//  main_test.go
//  tools/appconf
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
	"regexp"
	"strconv"
	"strings"
	"testing"
	"time"
)

const stockPbxproj = "\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n" +
	"\t\t\t\tMARKETING_VERSION = 1.0;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.application;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;\n" +
	"\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n" +
	"\t\t\t\tMARKETING_VERSION = 1.0;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.application;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;"

const stockGradle = `android {
    namespace = "com.jasonelle.application"

    defaultConfig {
        applicationId = "com.example.application"
        versionCode = 1
        versionName = "4.0.0"
    }
}`

const stockManifest = `<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Jasonelle">
    </application>
</manifest>`

func TestApplyXcodeProjectIDs(t *testing.T) {
	got, err := applyXcodeProjectIDs([]byte(stockPbxproj), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	for _, v := range []string{"com.mycompany.app", "com.mycompany.app.Tests", "com.mycompany.app.UITests"} {
		if n := strings.Count(string(got), "PRODUCT_BUNDLE_IDENTIFIER = "+v+";"); n != 2 {
			t.Errorf("bundle id %s count = %d, want 2\n%s", v, n, got)
		}
	}
	if strings.Count(string(got), "com.example") != 0 {
		t.Errorf("stock ids must be gone\n%s", got)
	}
}

func TestApplyXcodeProjectIDsIdempotent(t *testing.T) {
	once, err := applyXcodeProjectIDs([]byte(stockPbxproj), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyXcodeProjectIDs(once, "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyXcodeProjectIDsLiteralWildcard(t *testing.T) {
	got, err := applyXcodeProjectIDs([]byte(stockPbxproj), "com.example.*")
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(got), "PRODUCT_BUNDLE_IDENTIFIER = com.example.*;") {
		t.Errorf("wildcard app_id must be written literally:\n%s", got)
	}
}

func TestApplyXcodeProjectIDsMissingMarker(t *testing.T) {
	bad := strings.Replace(stockPbxproj, "com.example.application;", "", 1)
	if _, err := applyXcodeProjectIDs([]byte(bad), "com.mycompany.app"); err == nil {
		t.Errorf("unexpected marker count must error")
	}
}

func TestApplyXcodeProjectIDsEmptyID(t *testing.T) {
	if _, err := applyXcodeProjectIDs([]byte(stockPbxproj), ""); err == nil {
		t.Errorf("empty app_id must error")
	}
}

func TestApplyXcodeDisplayName(t *testing.T) {
	got, err := applyXcodeDisplayName([]byte(stockPbxproj), "com.example.application", "My App")
	if err != nil {
		t.Fatal(err)
	}
	if n := strings.Count(string(got), `INFOPLIST_KEY_CFBundleDisplayName = "My App";`); n != 2 {
		t.Errorf("display name count = %d, want 2\n%s", n, got)
	}
}

func TestApplyXcodeDisplayNameAppliesAfterIDs(t *testing.T) {
	ids, err := applyXcodeProjectIDs([]byte(stockPbxproj), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	got, err := applyXcodeDisplayName(ids, "com.mycompany.app", "My App")
	if err != nil {
		t.Fatal(err)
	}
	if n := strings.Count(string(got), `INFOPLIST_KEY_CFBundleDisplayName = "My App";`); n != 2 {
		t.Errorf("display name count = %d, want 2\n%s", n, got)
	}
}

func TestApplyXcodeDisplayNameIdempotent(t *testing.T) {
	once, err := applyXcodeDisplayName([]byte(stockPbxproj), "com.example.application", "My App")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyXcodeDisplayName(once, "com.example.application", "My App")
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyXcodeDisplayNameRename(t *testing.T) {
	once, err := applyXcodeDisplayName([]byte(stockPbxproj), "com.example.application", "My App")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyXcodeDisplayName(once, "com.example.application", "New Name")
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(twice), "My App") {
		t.Errorf("old name must be replaced\n%s", twice)
	}
	if n := strings.Count(string(twice), `INFOPLIST_KEY_CFBundleDisplayName = "New Name";`); n != 2 {
		t.Errorf("new name count = %d, want 2\n%s", n, twice)
	}
}

func TestApplyXcodeDisplayNameEmptyName(t *testing.T) {
	got, err := applyXcodeDisplayName([]byte(stockPbxproj), "com.example.application", "")
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != string(stockPbxproj) {
		t.Errorf("empty app_name must be a no-op")
	}
}

func TestApplyXcodeDisplayNameMissingMarker(t *testing.T) {
	bad := strings.Replace(stockPbxproj, "com.example.application;", "", 1)
	if _, err := applyXcodeDisplayName([]byte(bad), "com.example.application", "My App"); err == nil {
		t.Errorf("unexpected marker count must error")
	}
}

func TestApplyAndroidAppID(t *testing.T) {
	got, err := applyAndroidAppID([]byte(stockGradle), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(got), `applicationId = "com.mycompany.app"`) {
		t.Errorf("applicationId not patched:\n%s", got)
	}
	if strings.Contains(string(got), "com.example.application") {
		t.Errorf("stock applicationId must be gone:\n%s", got)
	}
}

func TestApplyAndroidAppIDIdempotent(t *testing.T) {
	once, err := applyAndroidAppID([]byte(stockGradle), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyAndroidAppID(once, "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyAndroidAppIDUnexpectedCount(t *testing.T) {
	bad := strings.Replace(stockGradle, "applicationId", "applicationId", 1)
	bad = bad + "\n    applicationId = \"com.example.other\""
	if _, err := applyAndroidAppID([]byte(bad), "com.mycompany.app"); err == nil {
		t.Errorf("multiple applicationId lines must error")
	}
}

func TestApplyAndroidAppIDEmptyID(t *testing.T) {
	if _, err := applyAndroidAppID([]byte(stockGradle), ""); err == nil {
		t.Errorf("empty app_id must error")
	}
}

func TestApplyAndroidLabel(t *testing.T) {
	got, err := applyAndroidLabel([]byte(stockManifest), "My App")
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(got), `android:label="My App"`) {
		t.Errorf("label not patched:\n%s", got)
	}
	if strings.Contains(string(got), "Jasonelle") {
		t.Errorf("stock label must be gone:\n%s", got)
	}
}

func TestApplyAndroidLabelIdempotent(t *testing.T) {
	once, err := applyAndroidLabel([]byte(stockManifest), "My App")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyAndroidLabel(once, "My App")
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyAndroidLabelEmptyName(t *testing.T) {
	got, err := applyAndroidLabel([]byte(stockManifest), "")
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != string(stockManifest) {
		t.Errorf("empty app_name must be a no-op")
	}
}

func TestApplyAndroidLabelUnexpectedCount(t *testing.T) {
	bad := stockManifest + `<application android:label="Other"></application>`
	if _, err := applyAndroidLabel([]byte(bad), "My App"); err == nil {
		t.Errorf("multiple labels must error")
	}
}

func TestApplyXcodeVersion(t *testing.T) {
	got, err := applyXcodeVersion([]byte(stockPbxproj), "com.example.application", "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if n := strings.Count(string(got), "MARKETING_VERSION = \"1.0\";"); n != 2 {
		t.Errorf("marketing version count = %d, want 2\n%s", n, got)
	}
	if n := strings.Count(string(got), "CURRENT_PROJECT_VERSION = 1620000000;"); n != 2 {
		t.Errorf("project version count = %d, want 2\n%s", n, got)
	}
}

func TestApplyXcodeVersionOnlyApplication(t *testing.T) {
	got, err := applyXcodeVersion([]byte(stockPbxproj), "com.example.application", "2.1", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(got), "MARKETING_VERSION = \"1.0\";") {
		t.Errorf("stock marketing version must be gone\n%s", got)
	}
	if n := strings.Count(string(got), "CURRENT_PROJECT_VERSION = 1620000000;"); n != 2 {
		t.Errorf("project version count = %d, want 2\n%s", n, got)
	}
}

func TestApplyXcodeVersionIdempotent(t *testing.T) {
	once, err := applyXcodeVersion([]byte(stockPbxproj), "com.example.application", "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyXcodeVersion(once, "com.example.application", "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyXcodeVersionEmptyVersion(t *testing.T) {
	got, err := applyXcodeVersion([]byte(stockPbxproj), "com.example.application", "", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != string(stockPbxproj) {
		t.Errorf("empty app_version must be a no-op")
	}
}

func TestApplyXcodeVersionMissingMarker(t *testing.T) {
	bad := strings.Replace(stockPbxproj, "com.example.application;", "", 1)
	if _, err := applyXcodeVersion([]byte(bad), "com.example.application", "1.0", 1620000000); err == nil {
		t.Errorf("unexpected config count must error")
	}
}

func TestApplyAndroidVersion(t *testing.T) {
	got, err := applyAndroidVersion([]byte(stockGradle), "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(got), "versionCode = 1620000000") {
		t.Errorf("versionCode not patched:\n%s", got)
	}
	if !strings.Contains(string(got), `versionName = "1.0"`) {
		t.Errorf("versionName not patched:\n%s", got)
	}
}

func TestApplyAndroidVersionIdempotent(t *testing.T) {
	once, err := applyAndroidVersion([]byte(stockGradle), "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyAndroidVersion(once, "1.0", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyAndroidVersionEmptyVersion(t *testing.T) {
	got, err := applyAndroidVersion([]byte(stockGradle), "", 1620000000)
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != string(stockGradle) {
		t.Errorf("empty app_version must be a no-op")
	}
}

func TestApplyAndroidVersionUnexpectedCount(t *testing.T) {
	bad := stockGradle + "\n    versionCode = 9"
	if _, err := applyAndroidVersion([]byte(bad), "1.0", 1620000000); err == nil {
		t.Errorf("multiple versionCode lines must error")
	}
}

func TestRun(t *testing.T) {
	dir := t.TempDir()
	xcfg := filepath.Join(dir, "xcode-config.json")
	acfg := filepath.Join(dir, "android-config.json")
	xproj := filepath.Join(dir, "project.pbxproj")
	aproj := filepath.Join(dir, "build.gradle.kts")
	manifest := filepath.Join(dir, "AndroidManifest.xml")
	for path, data := range map[string]string{
		xcfg:     `{"app_id": "com.mycompany.app", "app_name": "My App", "app_version": "1.0"}`,
		acfg:     `{"app_id": "com.mycompany.app", "app_name": "My App", "app_version": "1.0"}`,
		xproj:    stockPbxproj,
		aproj:    stockGradle,
		manifest: stockManifest,
	} {
		if err := os.WriteFile(path, []byte(data), 0644); err != nil {
			t.Fatal(err)
		}
	}

	before := time.Now().Unix()
	if err := run([]string{
		"--xcode-config", xcfg, "--xcode-project", xproj,
		"--android-config", acfg, "--android-project", aproj,
		"--android-manifest", manifest,
	}); err != nil {
		t.Fatal(err)
	}
	after := time.Now().Unix()

	xdata, err := os.ReadFile(xproj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(xdata), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app;") {
		t.Errorf("xcode project not patched:\n%s", xdata)
	}
	if n := strings.Count(string(xdata), `INFOPLIST_KEY_CFBundleDisplayName = "My App";`); n != 2 {
		t.Errorf("xcode display name count = %d, want 2:\n%s", n, xdata)
	}
	if n := strings.Count(string(xdata), `MARKETING_VERSION = "1.0";`); n != 2 {
		t.Errorf("xcode marketing version count = %d, want 2:\n%s", n, xdata)
	}

	adata, err := os.ReadFile(aproj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(adata), `applicationId = "com.mycompany.app"`) {
		t.Errorf("android project not patched:\n%s", adata)
	}
	if !strings.Contains(string(adata), `versionName = "1.0"`) {
		t.Errorf("android versionName not patched:\n%s", adata)
	}

	codeRe := regexp.MustCompile(`versionCode = ([0-9]+)`)
	codeMatch := codeRe.FindStringSubmatch(string(adata))
	if len(codeMatch) != 2 {
		t.Fatalf("android versionCode not patched:\n%s", adata)
	}
	code, err := strconv.ParseInt(codeMatch[1], 10, 64)
	if err != nil {
		t.Fatal(err)
	}
	if code < before || code > after {
		t.Errorf("android versionCode %d not within the run window [%d,%d]", code, before, after)
	}

	mdata, err := os.ReadFile(manifest)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(mdata), `android:label="My App"`) {
		t.Errorf("android manifest not patched:\n%s", mdata)
	}
}

func TestRunNoName(t *testing.T) {
	dir := t.TempDir()
	xcfg := filepath.Join(dir, "xcode-config.json")
	acfg := filepath.Join(dir, "android-config.json")
	xproj := filepath.Join(dir, "project.pbxproj")
	aproj := filepath.Join(dir, "build.gradle.kts")
	manifest := filepath.Join(dir, "AndroidManifest.xml")
	for path, data := range map[string]string{
		xcfg:     `{"app_id": "com.mycompany.app"}`,
		acfg:     `{"app_id": "com.mycompany.app"}`,
		xproj:    stockPbxproj,
		aproj:    stockGradle,
		manifest: stockManifest,
	} {
		if err := os.WriteFile(path, []byte(data), 0644); err != nil {
			t.Fatal(err)
		}
	}

	if err := run([]string{
		"--xcode-config", xcfg, "--xcode-project", xproj,
		"--android-config", acfg, "--android-project", aproj,
		"--android-manifest", manifest,
	}); err != nil {
		t.Fatal(err)
	}

	xdata, err := os.ReadFile(xproj)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(xdata), "INFOPLIST_KEY_CFBundleDisplayName") {
		t.Errorf("xcode must not set display name without app_name:\n%s", xdata)
	}
	mdata, err := os.ReadFile(manifest)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(mdata), `android:label="Jasonelle"`) {
		t.Errorf("android manifest must keep stock label without app_name:\n%s", mdata)
	}
	adata, err := os.ReadFile(aproj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(adata), `versionName = "4.0.0"`) || !strings.Contains(string(adata), "versionCode = 1") {
		t.Errorf("android must keep stock versions without app_version:\n%s", adata)
	}
}
