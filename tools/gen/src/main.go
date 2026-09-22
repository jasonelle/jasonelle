//
//  main.go
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
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"slices"
	"strings"
)

// stepOrder is the canonical pipeline order. plugins wipes
// build/<platform>/sources, so it must run before core.
var stepOrder = []string{"icon", "jsonc", "bundler", "plugins", "core", "link", "appconf"}

// genStep builds the arguments for every invocation of one pipeline step.
type genStep struct {
	name string
	cmds func(root, goos, goarch string) [][]string
}

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("gen", flag.ContinueOnError)
	steps := fs.String("steps", "", "comma-separated steps to run ("+strings.Join(stepOrder, ",")+"); default all")
	if err := fs.Parse(args); err != nil {
		return err
	}

	selected, err := selectSteps(*steps)
	if err != nil {
		return err
	}

	root, err := repoRoot()
	if err != nil {
		return err
	}

	return execute(root, selected, runtime.GOOS, runtime.GOARCH)
}

// repoRoot resolves the repository root from the running binary, which lives
// at <root>/tools/gen/dist/. Works from any working directory.
func repoRoot() (string, error) {
	self, err := os.Executable()
	if err != nil {
		return "", err
	}
	return filepath.Abs(filepath.Join(filepath.Dir(self), "..", "..", ".."))
}

func selectSteps(sel string) ([]genStep, error) {
	all := defaultSteps()
	if sel == "" {
		return all, nil
	}

	want := map[string]bool{}
	for _, name := range strings.Split(sel, ",") {
		name = strings.TrimSpace(name)
		if !slices.Contains(stepOrder, name) {
			return nil, fmt.Errorf("unknown step %q (valid: %s)", name, strings.Join(stepOrder, ", "))
		}
		want[name] = true
	}

	var out []genStep
	for _, s := range all {
		if want[s.name] {
			out = append(out, s)
		}
	}
	return out, nil
}

func defaultSteps() []genStep {
	return []genStep{
		{"icon", iconCmds},
		{"jsonc", jsoncCmds},
		{"bundler", bundlerCmds},
		{"plugins", pluginsCmds},
		{"core", noArgs},
		{"link", noArgs},
		{"appconf", noArgs},
	}
}

func noArgs(root, goos, goarch string) [][]string {
	return [][]string{{}}
}

func iconCmds(root, goos, goarch string) [][]string {
	return [][]string{{
		"--source", filepath.Join("lib", "common", "assets", "icon", "1024x1024.png"),
		"--xcode", filepath.Join("lib", "xcode"),
		"--android", filepath.Join("lib", "android"),
	}}
}

func jsoncCmds(root, goos, goarch string) [][]string {
	var out [][]string
	for _, plat := range []string{"xcode", "android"} {
		for _, f := range []string{"config.jsonc", "store.jsonc"} {
			out = append(out, []string{
				"--output", filepath.Join("build", plat, "config", f),
				filepath.Join("lib", "common", "config", f),
				filepath.Join("lib", plat, "config", f),
			})
		}
	}
	return out
}

func bundlerCmds(root, goos, goarch string) [][]string {
	esbuild := filepath.Join(root, "tools", "vendor", "esbuild", "dist", "esbuild-"+goos+"-"+goarch)
	if goos == "windows" {
		esbuild += ".exe"
	}
	var out [][]string
	for _, plat := range []string{"xcode", "android"} {
		out = append(out, []string{
			"--platform", plat,
			"--common", filepath.Join("lib", "common", "scripts"),
			"--platform-dir", filepath.Join("lib", plat, "scripts"),
			"--esbuild", esbuild,
			"--tsconfig", filepath.Join("lib", "common", "config", "bundler.json"),
			"--output", filepath.Join("build", plat, "scripts", "webview.js"),
		})
	}
	return out
}

func pluginsCmds(root, goos, goarch string) [][]string {
	return [][]string{{
		"--xcode", filepath.Join("build", "xcode", "config", "config.jsonc"),
		"--android", filepath.Join("build", "android", "config", "config.jsonc"),
	}}
}

// binPath returns the prebuilt dist binary for the current platform.
func binPath(root, name, goos, goarch string) string {
	p := filepath.Join(root, "tools", name, "dist", name+"-"+goos+"-"+goarch)
	if goos == "windows" {
		p += ".exe"
	}
	return p
}

// resetBuild wipes build/ and recreates the base layout every step expects.
func resetBuild(root string) error {
	build := filepath.Join(root, "build")
	if err := os.RemoveAll(build); err != nil {
		return err
	}
	for _, plat := range []string{"xcode", "android"} {
		for _, dir := range []string{"config", "scripts", "sources"} {
			if err := os.MkdirAll(filepath.Join(build, plat, dir), 0755); err != nil {
				return err
			}
		}
	}
	return nil
}

func execute(root string, steps []genStep, goos, goarch string) error {
	if err := resetBuild(root); err != nil {
		return fmt.Errorf("reset build: %w", err)
	}
	for _, s := range steps {
		bin := binPath(root, s.name, goos, goarch)
		if _, err := os.Stat(bin); err != nil {
			return fmt.Errorf("missing %s binary %s: build it first with 'cd tools/%s/src && task build'", s.name, bin, s.name)
		}
		for _, args := range s.cmds(root, goos, goarch) {
			fmt.Fprintf(os.Stderr, "==> gen %s %s\n", s.name, strings.Join(args, " "))
			cmd := exec.Command(bin, args...)
			cmd.Dir = root
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			if err := cmd.Run(); err != nil {
				return fmt.Errorf("%s: %w", s.name, err)
			}
		}
	}
	return nil
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
