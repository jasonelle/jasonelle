//
//  main_test.go
//  tools/appid
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

const stockPbxproj = "\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.application;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.application;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;\n" +
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;"

const stockGradle = `android {
    namespace = "com.jasonelle.application"

    defaultConfig {
        applicationId = "com.example.application"
    }
}`

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

func TestRun(t *testing.T) {
	dir := t.TempDir()
	xcfg := filepath.Join(dir, "xcode-config.json")
	acfg := filepath.Join(dir, "android-config.json")
	xproj := filepath.Join(dir, "project.pbxproj")
	aproj := filepath.Join(dir, "build.gradle.kts")
	for path, data := range map[string]string{
		xcfg:  `{"app_id": "com.mycompany.app"}`,
		acfg:  `{"app_id": "com.mycompany.app"}`,
		xproj: stockPbxproj,
		aproj: stockGradle,
	} {
		if err := os.WriteFile(path, []byte(data), 0644); err != nil {
			t.Fatal(err)
		}
	}

	if err := run([]string{
		"--xcode-config", xcfg, "--xcode-project", xproj,
		"--android-config", acfg, "--android-project", aproj,
	}); err != nil {
		t.Fatal(err)
	}

	xdata, err := os.ReadFile(xproj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(xdata), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app;") {
		t.Errorf("xcode project not patched:\n%s", xdata)
	}

	adata, err := os.ReadFile(aproj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(adata), `applicationId = "com.mycompany.app"`) {
		t.Errorf("android project not patched:\n%s", adata)
	}
}
