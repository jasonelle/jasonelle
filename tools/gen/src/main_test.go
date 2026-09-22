//
//  main_test.go
//  tools/gen
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-21
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
	"runtime"
	"strings"
	"testing"
)

func TestSelectSteps(t *testing.T) {
	all, err := selectSteps("")
	if err != nil {
		t.Fatal(err)
	}
	if len(all) != 7 {
		t.Fatalf("expected 7 steps, got %d", len(all))
	}
	for i, name := range stepOrder {
		if all[i].name != name {
			t.Fatalf("step %d: expected %q, got %q", i, name, all[i].name)
		}
	}

	subset, err := selectSteps("jsonc,link")
	if err != nil {
		t.Fatal(err)
	}
	if len(subset) != 2 || subset[0].name != "jsonc" || subset[1].name != "link" {
		t.Fatalf("expected [jsonc link], got %v", subsetNames(subset))
	}

	// Reversed input keeps canonical order.
	subset, err = selectSteps("link,jsonc")
	if err != nil {
		t.Fatal(err)
	}
	if len(subset) != 2 || subset[0].name != "jsonc" || subset[1].name != "link" {
		t.Fatalf("expected [jsonc link], got %v", subsetNames(subset))
	}

	// Whitespace is tolerated. A subset always runs in canonical pipeline order.
	subset, err = selectSteps(" core , plugins ")
	if err != nil {
		t.Fatal(err)
	}
	if len(subset) != 2 || subset[0].name != "plugins" || subset[1].name != "core" {
		t.Fatalf("expected [plugins core], got %v", subsetNames(subset))
	}
}

func TestSelectStepsUnknown(t *testing.T) {
	_, err := selectSteps("bogus")
	if err == nil || !strings.Contains(err.Error(), "unknown step \"bogus\"") {
		t.Fatalf("expected unknown step error, got %v", err)
	}
}

func TestRunBadStepsFlag(t *testing.T) {
	if err := run([]string{"--steps", "nope"}); err == nil || !strings.Contains(err.Error(), "unknown step") {
		t.Fatalf("expected unknown step error, got %v", err)
	}
}

func TestExecute(t *testing.T) {
	root := t.TempDir()
	log := filepath.Join(root, "calls.log")
	goos, goarch := runtime.GOOS, runtime.GOARCH

	for _, name := range stepOrder {
		writeStub(t, filepath.Join(root, "tools", name, "dist"), name+"-"+goos+"-"+goarch, name, log)
	}

	steps, err := selectSteps("icon,core")
	if err != nil {
		t.Fatal(err)
	}
	if err := execute(root, steps, goos, goarch); err != nil {
		t.Fatal(err)
	}

	data, err := os.ReadFile(log)
	if err != nil {
		t.Fatal(err)
	}
	got := string(data)

	want := []string{
		"icon:--source lib/common/assets/icon/1024x1024.png --xcode lib/xcode --android lib/android",
		"core:",
	}
	for _, line := range want {
		if !strings.Contains(got, line+"\n") {
			t.Fatalf("calls.log missing %q:\n%s", line, got)
		}
	}
	if strings.Contains(got, "jsonc:") {
		t.Fatalf("jsonc ran but was not selected:\n%s", got)
	}
	// icon must run before core.
	if strings.Index(got, "icon:") > strings.Index(got, "core:") {
		t.Fatalf("steps ran out of order:\n%s", got)
	}
}

func TestExecuteResetsBuild(t *testing.T) {
	root := t.TempDir()
	goos, goarch := runtime.GOOS, runtime.GOARCH
	for _, name := range stepOrder {
		writeStub(t, filepath.Join(root, "tools", name, "dist"), name+"-"+goos+"-"+goarch, name, filepath.Join(root, "calls.log"))
	}
	stale := filepath.Join(root, "build", "xcode", "stale.txt")
	if err := os.MkdirAll(filepath.Dir(stale), 0755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(stale, []byte("old"), 0644); err != nil {
		t.Fatal(err)
	}

	steps, err := selectSteps("core")
	if err != nil {
		t.Fatal(err)
	}
	if err := execute(root, steps, goos, goarch); err != nil {
		t.Fatal(err)
	}

	if _, err := os.Stat(stale); !os.IsNotExist(err) {
		t.Fatalf("stale build file survived reset: %v", err)
	}
	for _, plat := range []string{"xcode", "android"} {
		for _, dir := range []string{"config", "scripts", "sources"} {
			p := filepath.Join(root, "build", plat, dir)
			if fi, err := os.Stat(p); err != nil || !fi.IsDir() {
				t.Fatalf("missing base dir %s: %v", p, err)
			}
		}
	}
}

func TestExecuteMissingBinary(t *testing.T) {
	root := t.TempDir()
	steps, err := selectSteps("core")
	if err != nil {
		t.Fatal(err)
	}
	goos, goarch := runtime.GOOS, runtime.GOARCH
	err = execute(root, steps, goos, goarch)
	if err == nil {
		t.Fatal("expected error for missing binary")
	}
	want := "missing core binary"
	if !strings.Contains(err.Error(), want) {
		t.Fatalf("expected error containing %q, got %v", want, err)
	}
	if !strings.Contains(err.Error(), binPath(root, "core", goos, goarch)) {
		t.Fatalf("expected error to name binary path, got %v", err)
	}
}

func subsetNames(steps []genStep) []string {
	var out []string
	for _, s := range steps {
		out = append(out, s.name)
	}
	return out
}

// writeStub creates an executable fake tool labelled `label` that logs
// "label:args" per call.
func writeStub(t *testing.T, dir, fileName, label, log string) {
	t.Helper()
	if err := os.MkdirAll(dir, 0755); err != nil {
		t.Fatal(err)
	}
	target := filepath.Join(dir, fileName)
	if runtime.GOOS == "windows" {
		target += ".exe"
	}
	var body string
	if runtime.GOOS == "windows" {
		body = "@echo off\r\n"
		body += "echo " + label + ":%*>> \"" + log + "\"\r\n"
	} else {
		body = "#!/bin/sh\n"
		body += "printf '%s:%s\\n' \"" + label + "\" \"$*\" >> \"" + log + "\"\n"
	}
	if err := os.WriteFile(target, []byte(body), 0755); err != nil {
		t.Fatal(err)
	}
}
