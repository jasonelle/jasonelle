//  main_test.go
//  tools/icon
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
	"image"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestResize(t *testing.T) {
	src := image.NewRGBA(image.Rect(0, 0, 1024, 1024))
	dst := resize(src, 48)
	if w, h := dst.Bounds().Dx(), dst.Bounds().Dy(); w != 48 || h != 48 {
		t.Fatalf("got %dx%d, want 48x48", w, h)
	}
}

func TestRunGeneratesIcons(t *testing.T) {
	dir := t.TempDir()
	src := filepath.Join(dir, "1024x1024.png")
	if err := writeIcon(image.NewRGBA(image.Rect(0, 0, 1024, 1024)), src, 1024); err != nil {
		t.Fatal(err)
	}
	android := filepath.Join(dir, "android")
	xcode := filepath.Join(dir, "xcode")

	if err := run([]string{"--source", src, "--android", android, "--xcode", xcode}); err != nil {
		t.Fatal(err)
	}

	want := []string{
		filepath.Join(android, "assets", "icon", "res", "mipmap-mdpi", "ic_launcher.png"),
		filepath.Join(android, "assets", "icon", "res", "mipmap-xxxhdpi", "ic_launcher_round.png"),
		filepath.Join(android, "assets", "icon", "store", "icon-512.png"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "Contents.json"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "icon-180.png"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "icon-1024.png"),
	}
	for _, path := range want {
		if _, err := os.Stat(path); err != nil {
			t.Errorf("missing %s: %v", path, err)
		}
	}
}

func TestRunRequiresOutputFlag(t *testing.T) {
	if err := run(nil); err == nil || !strings.Contains(err.Error(), "xcode or -android") {
		t.Fatalf("got %v, want missing output flag error", err)
	}
}
