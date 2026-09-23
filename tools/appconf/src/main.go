//
//  main.go
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
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("appconf", flag.ContinueOnError)
	xcodeConfig := fs.String("xcode-config", "build/xcode/config/config.jsonc", "path to the merged Xcode config.jsonc")
	xcodeProject := fs.String("xcode-project", "build/xcode/sources/Application/Application.xcodeproj/project.pbxproj", "path to the Xcode project.pbxproj")
	androidConfig := fs.String("android-config", "build/android/config/config.jsonc", "path to the merged Android config.jsonc")
	androidProject := fs.String("android-project", "build/android/sources/Application/build.gradle.kts", "path to the Android Application build.gradle.kts")
	androidManifest := fs.String("android-manifest", "build/android/sources/Application/src/main/AndroidManifest.xml", "path to the Android Application AndroidManifest.xml")
	if err := fs.Parse(args); err != nil {
		return err
	}

	cfg, err := readConfig(*xcodeConfig)
	if err != nil {
		return err
	}
	build := time.Now().Unix()

	xcodeContent, err := os.ReadFile(*xcodeProject)
	if err != nil {
		return err
	}
	patched, err := applyXcodeProjectIDs(xcodeContent, cfg.AppID)
	if err != nil {
		return err
	}
	patched, err = applyXcodeDisplayName(patched, cfg.AppID, cfg.AppName)
	if err != nil {
		return err
	}
	patched, err = applyXcodeVersion(patched, cfg.AppID, cfg.AppVersion, build)
	if err != nil {
		return err
	}
	if string(xcodeContent) != string(patched) {
		if err := os.WriteFile(*xcodeProject, patched, 0644); err != nil {
			return err
		}
	}

	cfg, err = readConfig(*androidConfig)
	if err != nil {
		return err
	}

	androidContent, err := os.ReadFile(*androidProject)
	if err != nil {
		return err
	}
	patched, err = applyAndroidAppID(androidContent, cfg.AppID)
	if err != nil {
		return err
	}
	patched, err = applyAndroidVersion(patched, cfg.AppVersion, build)
	if err != nil {
		return err
	}
	if string(androidContent) != string(patched) {
		if err := os.WriteFile(*androidProject, patched, 0644); err != nil {
			return err
		}
	}

	manifestContent, err := os.ReadFile(*androidManifest)
	if err != nil {
		return err
	}
	patched, err = applyAndroidLabel(manifestContent, cfg.AppName)
	if err != nil {
		return err
	}
	if string(manifestContent) != string(patched) {
		if err := os.WriteFile(*androidManifest, patched, 0644); err != nil {
			return err
		}
	}
	return nil
}

type appConfig struct {
	AppID      string `json:"app_id"`
	AppName    string `json:"app_name"`
	AppVersion string `json:"app_version"`
}

// readConfig reads the JSON config properties. app_id is required; app_name is
// optional and an empty value simply leaves the app name untouched.
func readConfig(path string) (appConfig, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return appConfig{}, err
	}
	var cfg appConfig
	if err := json.Unmarshal(data, &cfg); err != nil {
		return appConfig{}, fmt.Errorf("%s: %w", path, err)
	}
	if cfg.AppID == "" {
		return appConfig{}, fmt.Errorf("%s: app_id is required", path)
	}
	return cfg, nil
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

var xcodeDisplayNameRe = regexp.MustCompile(`\n(\t+)INFOPLIST_KEY_CFBundleDisplayName = "[^"]*";`)

// applyXcodeDisplayName adds INFOPLIST_KEY_CFBundleDisplayName to the
// Application target's two build configurations (Debug + Release), anchoring
// on the Application PRODUCT_BUNDLE_IDENTIFIER line (the one with no suffix).
// A missing appName is a no-op. When the name is already applied twice the
// content is unchanged; when a different name is applied twice it is replaced;
// any other count means the file was customized and the tool fails.
func applyXcodeDisplayName(content []byte, appID, appName string) ([]byte, error) {
	if appName == "" {
		return content, nil
	}
	add := "\n\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = \"" + appName + "\";"
	marker := "PRODUCT_BUNDLE_IDENTIFIER = " + appID + ";"
	stockN := strings.Count(string(content), marker)
	oldN := len(xcodeDisplayNameRe.FindAll(content, -1))
	switch {
	case oldN == 2:
		return xcodeDisplayNameRe.ReplaceAll(content, []byte(add)), nil
	case stockN == 2:
		out := strings.Replace(string(content), marker, marker+add, 2)
		return []byte(out), nil
	default:
		return nil, fmt.Errorf("unexpected %q occurrences (markers: %d, names: %d)", marker, stockN, oldN)
	}
}

// applyAndroidLabel rewrites the android:label value in the AndroidManifest.xml
// content to match appName. A missing appName is a no-op. Exactly one label
// line is expected; when its value already equals appName the content is
// returned unchanged. Any other count means the file was customized and the
// tool fails rather than guess.
func applyAndroidLabel(content []byte, appName string) ([]byte, error) {
	if appName == "" {
		return content, nil
	}
	matches := androidLabelRe.FindAllStringSubmatch(string(content), -1)
	if len(matches) != 1 {
		return nil, fmt.Errorf("expected exactly one android:label line, found %d", len(matches))
	}
	if matches[0][1] == appName {
		return content, nil
	}
	return androidLabelRe.ReplaceAll(content, []byte("android:label=\""+appName+"\"")), nil
}

var androidAppIDRe = regexp.MustCompile(`applicationId = "([^"]*)"`)
var androidLabelRe = regexp.MustCompile(`android:label="([^"]*)"`)

var xcodeProjectVersionRe = regexp.MustCompile(`CURRENT_PROJECT_VERSION = [0-9]+;`)
var xcodeMarketingVersionRe = regexp.MustCompile(`MARKETING_VERSION = [^;\n]+;`)

var androidVersionCodeRe = regexp.MustCompile(`versionCode = [0-9]+`)
var androidVersionNameRe = regexp.MustCompile(`versionName = "[^"]*"`)

// applyXcodeVersion sets the Application target's MARKETING_VERSION to version
// and CURRENT_PROJECT_VERSION to build in its two build configurations
// (Debug + Release), anchoring on the Application PRODUCT_BUNDLE_IDENTIFIER
// line (the one with no suffix). A missing version is a no-op. When the values
// are already set the content is unchanged; when the Application configs do not
// appear exactly twice the tool fails rather than guess.
func applyXcodeVersion(content []byte, appID, version string, build int64) ([]byte, error) {
	if version == "" {
		return content, nil
	}
	blockRe := regexp.MustCompile(
		`CURRENT_PROJECT_VERSION = [0-9]+;\n(?s:.+?)MARKETING_VERSION = [^;\n]+;\n\t+PRODUCT_BUNDLE_IDENTIFIER = ` +
			regexp.QuoteMeta(appID) + `;`,
	)
	if n := len(blockRe.FindAll(content, -1)); n != 2 {
		return nil, fmt.Errorf("unexpected Application build configs found: %d, want 2", n)
	}
	return blockRe.ReplaceAllFunc(content, func(m []byte) []byte {
		out := xcodeProjectVersionRe.ReplaceAll(m, []byte("CURRENT_PROJECT_VERSION = "+strconv.FormatInt(build, 10)+";"))
		out = xcodeMarketingVersionRe.ReplaceAll(out, []byte("MARKETING_VERSION = \""+version+"\";"))
		return out
	}), nil
}

// applyAndroidVersion rewrites the versionCode and versionName values in the
// build.gradle.kts content to match build and version. A missing version is a
// no-op. Exactly one versionCode and one versionName line are expected; when
// both already match the content is returned unchanged. Any other count means
// the file was customized and the tool fails rather than guess.
func applyAndroidVersion(content []byte, version string, build int64) ([]byte, error) {
	if version == "" {
		return content, nil
	}
	if n := len(androidVersionCodeRe.FindAll(content, -1)); n != 1 {
		return nil, fmt.Errorf("expected exactly one versionCode line, found %d", n)
	}
	if n := len(androidVersionNameRe.FindAll(content, -1)); n != 1 {
		return nil, fmt.Errorf("expected exactly one versionName line, found %d", n)
	}
	if strings.Contains(string(content), "versionCode = "+strconv.FormatInt(build, 10)) &&
		strings.Contains(string(content), `versionName = "`+version+`"`) {
		return content, nil
	}
	out := androidVersionCodeRe.ReplaceAllString(string(content), "versionCode = "+strconv.FormatInt(build, 10))
	out = androidVersionNameRe.ReplaceAllString(out, `versionName = "`+version+`"`)
	return []byte(out), nil
}

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
