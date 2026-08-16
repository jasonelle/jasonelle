//  main_test.go
//  tools/jsonc
//
//  Created by clsource on 2026-08-16
//
//  Copyright (c) Jasonelle
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
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
	"reflect"
	"strings"
	"testing"
)

func writeJSONC(t *testing.T, dir, name, content string) string {
	t.Helper()
	path := filepath.Join(dir, name)
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatal(err)
	}
	return path
}

func TestRunMergesJSONC(t *testing.T) {
	dir := t.TempDir()
	base := writeJSONC(t, dir, "base.jsonc", `{
		// base comment
		"colors": {"bg": "red", "accent": "blue"},
		"sizes": [1, 2],
		"name": "base",
	}`)
	over := writeJSONC(t, dir, "over.jsonc", `{
		/* block comment */
		"colors": {"accent": "green", "fg": "white"},
		"sizes": [9],
	}`)
	out := filepath.Join(dir, "out.jsonc")

	if err := run([]string{"--output", out, base, over}); err != nil {
		t.Fatal(err)
	}

	data, err := os.ReadFile(out)
	if err != nil {
		t.Fatal(err)
	}
	got := map[string]any{}
	if err := json.Unmarshal(data, &got); err != nil {
		t.Fatalf("output is not valid JSON: %v\n%s", err, data)
	}
	want := map[string]any{
		"colors": map[string]any{"bg": "red", "accent": "green", "fg": "white"},
		"sizes":  []any{float64(9)},
		"name":   "base",
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("got %#v, want %#v", got, want)
	}
	if strings.Contains(string(data), "//") {
		t.Errorf("output contains a comment:\n%s", data)
	}
}

func TestRunErrors(t *testing.T) {
	dir := t.TempDir()
	if err := run(nil); err == nil || !strings.Contains(err.Error(), "-output") {
		t.Fatalf("got %v, want missing -output error", err)
	}
	bad := writeJSONC(t, dir, "bad.jsonc", `{"a": }`)
	if err := run([]string{"--output", filepath.Join(dir, "o.jsonc"), bad}); err == nil {
		t.Fatal("got nil, want invalid JSON error")
	}
	if err := run([]string{"--output", filepath.Join(dir, "o.jsonc")}); err == nil {
		t.Fatal("got nil, want missing input error")
	}
}
