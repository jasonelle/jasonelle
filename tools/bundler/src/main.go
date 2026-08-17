//  main.go
//  tools/bundler
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
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("bundler", flag.ContinueOnError)
	platform := fs.String("platform", "", "target platform: android or xcode")
	common := fs.String("common", "", "path to common scripts directory")
	platformDir := fs.String("platform-dir", "", "path to platform-specific scripts")
	esbuildBin := fs.String("esbuild", "", "path to vendored esbuild binary")
	output := fs.String("output", "", "output path for bundled JS")
	tsconfig := fs.String("tsconfig", "lib/common/config/bundler.json", "path to tsconfig")
	target := fs.String("target", "safari11", "esbuild target")
	banner := fs.String("banner", "/*--automatically-generated-by-esbuild-jasonelle--*/", "banner comment")

	if err := fs.Parse(args); err != nil {
		return err
	}

	if *platform == "" || *common == "" || *platformDir == "" || *esbuildBin == "" || *output == "" {
		return errors.New("--platform, --common, --platform-dir, --esbuild, and --output are required")
	}

	if *platform != "android" && *platform != "xcode" {
		return fmt.Errorf("--platform must be 'android' or 'xcode', got '%s'", *platform)
	}

	outputDir := filepath.Dir(*output)
	buildDir := filepath.Dir(outputDir)
	jsDir := filepath.Join(buildDir, "js")
	scriptsDir := filepath.Join(buildDir, "scripts")

	os.RemoveAll(jsDir)
	os.RemoveAll(scriptsDir)

	if err := os.MkdirAll(jsDir, 0755); err != nil {
		return err
	}
	if err := os.MkdirAll(scriptsDir, 0755); err != nil {
		return err
	}

	if err := copyDir(*common, scriptsDir); err != nil {
		return fmt.Errorf("copying common scripts: %w", err)
	}

	if err := copyDir(*platformDir, scriptsDir); err != nil {
		return fmt.Errorf("copying platform scripts: %w", err)
	}

	mainTS := filepath.Join(scriptsDir, "main.ts")
	cmd := exec.Command(*esbuildBin, mainTS,
		"--outdir="+jsDir,
		"--bundle",
		"--target="+*target,
		"--analyze",
		"--tsconfig="+*tsconfig,
		"--banner:js="+*banner,
	)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("esbuild failed: %w", err)
	}

	mainJS := filepath.Join(jsDir, "main.js")
	if err := os.Rename(mainJS, *output); err != nil {
		return fmt.Errorf("moving output: %w", err)
	}

	os.RemoveAll(jsDir)

	return nil
}

func copyDir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		dest := filepath.Join(dst, rel)

		if info.IsDir() {
			return os.MkdirAll(dest, 0755)
		}

		return copyFile(path, dest)
	})
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	return err
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
