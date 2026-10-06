//
//  tools/bundler/main_test.go
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-17
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

func TestInvalidPlatform(t *testing.T) {
	err := run([]string{"--platform", "invalid", "--common", ".", "--platform-dir", ".", "--esbuild", ".", "--output", "."})
	if err == nil {
		t.Fatal("expected error for invalid platform")
	}
	if !strings.Contains(err.Error(), "--platform must be") {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestMissingRequiredFlags(t *testing.T) {
	err := run([]string{})
	if err == nil {
		t.Fatal("expected error for missing flags")
	}
}

func TestCopyDir(t *testing.T) {
	src := t.TempDir()
	dst := t.TempDir()

	os.WriteFile(filepath.Join(src, "test.ts"), []byte("const x = 1;"), 0644)
	os.MkdirAll(filepath.Join(src, "sub"), 0755)
	os.WriteFile(filepath.Join(src, "sub", "nested.ts"), []byte("const y = 2;"), 0644)

	if err := copyDir(src, dst); err != nil {
		t.Fatalf("copyDir failed: %v", err)
	}

	data, err := os.ReadFile(filepath.Join(dst, "test.ts"))
	if err != nil {
		t.Fatalf("failed to read copied file: %v", err)
	}
	if string(data) != "const x = 1;" {
		t.Fatalf("file content mismatch: got %q", string(data))
	}

	data, err = os.ReadFile(filepath.Join(dst, "sub", "nested.ts"))
	if err != nil {
		t.Fatalf("failed to read nested file: %v", err)
	}
	if string(data) != "const y = 2;" {
		t.Fatalf("nested file content mismatch: got %q", string(data))
	}
}

func TestCopyFile(t *testing.T) {
	src := t.TempDir()
	dst := t.TempDir()

	srcFile := filepath.Join(src, "test.ts")
	dstFile := filepath.Join(dst, "test.ts")

	os.WriteFile(srcFile, []byte("hello"), 0644)

	if err := copyFile(srcFile, dstFile); err != nil {
		t.Fatalf("copyFile failed: %v", err)
	}

	data, err := os.ReadFile(dstFile)
	if err != nil {
		t.Fatalf("failed to read copied file: %v", err)
	}
	if string(data) != "hello" {
		t.Fatalf("file content mismatch: got %q", string(data))
	}
}
