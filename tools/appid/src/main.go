//
//  main.go
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
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("appid", flag.ContinueOnError)
	xcodeConfig := fs.String("xcode-config", "build/xcode/config/config.jsonc", "path to the merged Xcode config.jsonc")
	xcodeProject := fs.String("xcode-project", "build/xcode/sources/Application/Application.xcodeproj/project.pbxproj", "path to the Xcode project.pbxproj")
	androidConfig := fs.String("android-config", "build/android/config/config.jsonc", "path to the merged Android config.jsonc")
	androidProject := fs.String("android-project", "build/android/sources/Application/build.gradle.kts", "path to the Android Application build.gradle.kts")
	if err := fs.Parse(args); err != nil {
		return err
	}

	appID, err := readAppID(*xcodeConfig)
	if err != nil {
		return err
	}

	xcodeContent, err := os.ReadFile(*xcodeProject)
	if err != nil {
		return err
	}
	patched, err := applyXcodeProjectIDs(xcodeContent, appID)
	if err != nil {
		return err
	}
	if string(xcodeContent) != string(patched) {
		if err := os.WriteFile(*xcodeProject, patched, 0644); err != nil {
			return err
		}
	}

	appID, err = readAppID(*androidConfig)
	if err != nil {
		return err
	}

	androidContent, err := os.ReadFile(*androidProject)
	if err != nil {
		return err
	}
	patched, err = applyAndroidAppID(androidContent, appID)
	if err != nil {
		return err
	}
	if string(androidContent) != string(patched) {
		if err := os.WriteFile(*androidProject, patched, 0644); err != nil {
			return err
		}
	}
	return nil
}

// readAppID reads the JSON config and returns the app_id property.
func readAppID(path string) (string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	var cfg struct {
		AppID string `json:"app_id"`
	}
	if err := json.Unmarshal(data, &cfg); err != nil {
		return "", fmt.Errorf("%s: %w", path, err)
	}
	if cfg.AppID == "" {
		return "", fmt.Errorf("%s: app_id is required", path)
	}
	return cfg.AppID, nil
}

// xcodeBundles pairs each target's stock bundle id marker with the suffix
// appended to the app_id for that target. The full
// "PRODUCT_BUNDLE_IDENTIFIER = <value>;" token is matched, so an Application id
// never collides with the Tests ids. Matching is case-sensitive.
var xcodeBundles = []struct {
	stock string
	suf   string
}{
	{"com.example.application", ""},
	{"com.example.ApplicationTests", ".Tests"},
	{"com.example.ApplicationUITests", ".UITests"},
}

// applyXcodeProjectIDs rewrites the PRODUCT_BUNDLE_IDENTIFIER values in the
// pbxproj content to match appID. Each marker must appear exactly twice (Debug
// + Release) or, when the file was already patched, the new value must appear
// twice. Any other count means the file was customized and the tool fails
// rather than guess.
func applyXcodeProjectIDs(content []byte, appID string) ([]byte, error) {
	if appID == "" {
		return nil, fmt.Errorf("app_id must not be empty")
	}
	out := string(content)
	for _, b := range xcodeBundles {
		marker := "PRODUCT_BUNDLE_IDENTIFIER = " + b.stock + ";"
		repl := "PRODUCT_BUNDLE_IDENTIFIER = " + appID + b.suf + ";"
		stockN := strings.Count(out, marker)
		newN := strings.Count(out, repl)
		switch {
		case stockN == 2:
			out = strings.ReplaceAll(out, marker, repl)
		case newN != 2:
			return nil, fmt.Errorf("unexpected %q occurrences (stock: %d, patched: %d)", marker, stockN, newN)
		}
	}
	return []byte(out), nil
}

var androidAppIDRe = regexp.MustCompile(`applicationId = "([^"]*)"`)

// applyAndroidAppID rewrites the applicationId value in the build.gradle.kts
// content to match appID. Exactly one applicationId line is expected; when its
// value already equals appID the content is returned unchanged. Any other
// count means the file was customized and the tool fails rather than guess.
func applyAndroidAppID(content []byte, appID string) ([]byte, error) {
	if appID == "" {
		return nil, fmt.Errorf("app_id must not be empty")
	}
	matches := androidAppIDRe.FindAllStringSubmatch(string(content), -1)
	if len(matches) != 1 {
		return nil, fmt.Errorf("expected exactly one applicationId line, found %d", len(matches))
	}
	if matches[0][1] == appID {
		return content, nil
	}
	repl := "applicationId = \"" + appID + "\""
	out := androidAppIDRe.ReplaceAllString(string(content), repl)
	return []byte(out), nil
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
