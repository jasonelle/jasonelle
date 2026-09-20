# bundleid Tool Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `tools/bundleid`, a Go tool that sets the Xcode `PRODUCT_BUNDLE_IDENTIFIER` values to match the `app_id` in the merged config.

**Architecture:** Read `app_id` from `build/xcode/config/config.jsonc` (plain JSON after the `jsonc` merge). Rewrite `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj` by value-anchored string replacement of the stock `PRODUCT_BUNDLE_IDENTIFIER = <value>;` lines (0 or 2 occurrences per target; 2 → replace, 2 of the new value → already patched no-op, otherwise error).

**Tech Stack:** Go 1.26, standard library only (`flag`, `encoding/json`, `strings`, `os`, `path/filepath`). No external dependencies.

## Global Constraints

- Module name: `jasonelle.com/jasonelle/tools/bundleid`.
- Tool directory: `tools/bundleid/` with `src/`, `dist/`, `README.md` (per `tool-create-go.md` conventions).
- Every `src/*.go` file carries the full dual-license AGPLv3 + MPLv2 header.
- `main()` delegates to `run([]string) error`; `fatal()` is the only `os.Exit` call site; flags via `flag.NewFlagSet` inside `run()`.
- Cross-compile binaries `bundleid-<os>-<arch>` (`.exe` on Windows) into `tools/bundleid/dist/`.
- `dist/` is git-tracked and committed after building.
- Values written literally; no wildcard translation.
- `app_id` missing or empty → error.
- Empty `app_id` and unexpected marker counts are the only error conditions; the tool must be idempotent.

---

### Task 1: Scaffold `tools/bundleid`

**Files:**
- Create: `tools/bundleid/src/go.mod`
- Create: `tools/bundleid/src/VERSION`
- Create: `tools/bundleid/src/.gitignore`
- Create: `tools/bundleid/src/Taskfile.yml`
- Create: `tools/bundleid/README.md`
- Create: `tools/bundleid/src/main.go`

**Interfaces:**
- Produces: package `main` with `run([]string) error` and `fatal(error)`; the `applyBundleIDs` and `readAppID` functions land in Task 2, so `run()` is incomplete until then (this is fine — Task 2 completes it).

- [ ] **Step 1: Create `tools/bundleid/src/go.mod`**

```
module jasonelle.com/jasonelle/tools/bundleid

go 1.26
```

- [ ] **Step 2: Create `tools/bundleid/src/VERSION`**

```
1.0.0
```

- [ ] **Step 3: Create `tools/bundleid/src/.gitignore`**

```
bundleid
```

- [ ] **Step 4: Create `tools/bundleid/src/Taskfile.yml`**

```yaml
# yaml-language-server: $schema=https://taskfile.dev/schema.json
# A Taskfile.yml as an alternative to Makefile
version: "3.17"

tasks:
  default:
    cmds:
      - task build
  build:
    aliases:
      - b
    desc: Build cross-platform binaries into ../dist
    cmds:
      - rm -rf ../dist
      - mkdir -p ../dist
      - GOOS=darwin GOARCH=amd64 go build -o ../dist/bundleid-darwin-amd64 .
      - GOOS=darwin GOARCH=arm64 go build -o ../dist/bundleid-darwin-arm64 .
      - GOOS=linux GOARCH=amd64 go build -o ../dist/bundleid-linux-amd64 .
      - GOOS=windows GOARCH=amd64 go build -o ../dist/bundleid-windows-amd64.exe .
  test:
    aliases:
      - t
    desc: Test the current version of the bundleid tool
    cmds:
      - go test
  format:
    aliases:
      - f
    desc: Format the current project
    cmds:
      - go fmt
  version.major:
    aliases:
      - v
    desc: Bump VERSION to the next major version
    cmds:
      - awk -F. '{print ($1 + 1) ".0.0"}' VERSION > VERSION.tmp && mv VERSION.tmp VERSION
  version.minor:
    aliases:
      - vm
    desc: Bump VERSION to the next minor version
    cmds:
      - awk -F. '{print $1 "." ($2 + 1) ".0"}' VERSION > VERSION.tmp && mv VERSION.tmp VERSION
  version.patch:
    aliases:
      - vp
    desc: Bump VERSION to the next patch version
    cmds:
      - awk -F. '{print $1 "." $2 "." ($3 + 1)}' VERSION > VERSION.tmp && mv VERSION.tmp VERSION
```

- [ ] **Step 5: Create `tools/bundleid/README.md`**

```markdown
# Bundleid

Sets the Xcode bundle identifiers in the assembled project to the `app_id`
from the merged config. Run after `task core`, against `build/xcode/sources/`.

## Usage

From the repository root:

```
tools/bundleid/dist/bundleid-<os>-<arch>
```

Flags:

- `--config` (default `build/xcode/config/config.jsonc`): merged config with
  the `app_id` property.
- `--project` (default
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`):
  project file to patch.

The tool rewrites `PRODUCT_BUNDLE_IDENTIFIER` for the Application
(`app_id`), ApplicationTests (`app_id.Tests`) and ApplicationUITests
(`app_id.UITests`) targets in both Debug and Release configs. Values are
written literally. Re-running is a no-op.

## Building from source

From `tools/bundleid/src`:

- `task build` (`b`) cross-compiles binaries into `tools/bundleid/dist/`
- `task test` (`t`) runs the test suite
```

- [ ] **Step 6: Create `tools/bundleid/src/main.go` with the header and `run`/`fatal` skeleton**

```go
//
//  main.go
//  tools/bundleid
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
	"fmt"
	"os"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	return nil
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
```

Note: `run` is a stub until Task 2 fills it in.

- [ ] **Step 7: Commit**

```bash
git add tools/bundleid
git commit -m "✨ feat(bundleid): scaffold tools/bundleid"
```

---

### Task 2: Implement the bundle identifier rewrite

**Files:**
- Create: `tools/bundleid/src/main_test.go`
- Modify: `tools/bundleid/src/main.go`

**Interfaces:**
- Consumes: stub `run([]string) error` from Task 1.
- Produces:
  - `readAppID(path string) (string, error)` — reads JSON config, returns `app_id`, error if missing/empty.
  - `applyBundleIDs(content []byte, appID string) ([]byte, error)` — returns patched content, error on unexpected marker counts.
  - `run([]string) error` — now implemented: parses `--config` / `--project`, reads config, patches, writes file only when changed.

- [ ] **Step 1: Write the failing test**

`tools/bundleid/src/main_test.go` (full license header, then):

```go
package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

const stockPbxproj = strings.Join([]string{
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.Application;",
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;",
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;",
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.Application;",
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationTests;",
	"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.ApplicationUITests;",
}, "\n")

func TestApplyBundleIDs(t *testing.T) {
	got, err := applyBundleIDs([]byte(stockPbxproj), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	want := strings.Count(string(got), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app;") +
		strings.Count(string(got), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app.Tests;") +
		strings.Count(string(got), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app.UITests;")
	if want != 6 {
		t.Errorf("patched bundle ids = %d, want 6\n%s", want, got)
	}
	if strings.Count(string(got), "com.example") != 0 {
		t.Errorf("stock ids must be gone\n%s", got)
	}
}

func TestApplyBundleIDsIdempotent(t *testing.T) {
	once, err := applyBundleIDs([]byte(stockPbxproj), "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	twice, err := applyBundleIDs(once, "com.mycompany.app")
	if err != nil {
		t.Fatal(err)
	}
	if string(twice) != string(once) {
		t.Errorf("second run must be a no-op")
	}
}

func TestApplyBundleIDsLiteralWildcard(t *testing.T) {
	got, err := applyBundleIDs([]byte(stockPbxproj), "com.example.*")
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(got), "PRODUCT_BUNDLE_IDENTIFIER = com.example.*;") {
		t.Errorf("wildcard app_id must be written literally:\n%s", got)
	}
}

func TestApplyBundleIDsMissingMarker(t *testing.T) {
	bad := strings.Replace(stockPbxproj, "com.example.Application;", "com.example.Application;", 1)
	// Remove one Application marker to simulate an unexpected file.
	bad = strings.Replace(bad, "com.example.Application;", "", 1)
	if _, err := applyBundleIDs([]byte(bad), "com.mycompany.app"); err == nil {
		t.Errorf("unexpected marker count must error")
	}
}

func TestApplyBundleIDsEmptyID(t *testing.T) {
	if _, err := applyBundleIDs([]byte(stockPbxproj), ""); err == nil {
		t.Errorf("empty app_id must error")
	}
}

func TestRun(t *testing.T) {
	dir := t.TempDir()
	cfg := filepath.Join(dir, "config.jsonc")
	proj := filepath.Join(dir, "project.pbxproj")
	if err := os.WriteFile(cfg, []byte(`{"app_id": "com.mycompany.app"}`), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(proj, []byte(stockPbxproj), 0644); err != nil {
		t.Fatal(err)
	}

	if err := run([]string{"--config", cfg, "--project", proj}); err != nil {
		t.Fatal(err)
	}

	data, err := os.ReadFile(proj)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(data), "PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.app;") {
		t.Errorf("project not patched:\n%s", data)
	}
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd tools/bundleid/src && go test ./...` (or `task test` from `tools/bundleid/src`)
Expected: FAIL — `applyBundleIDs` / `readAppID` undefined.

- [ ] **Step 3: Implement `main.go`**

Append to the header/skel from Task 1:

```go
import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strings"
)

// bundles pairs each target's stock bundle id marker with the value that
// replaces it. The full "PRODUCT_BUNDLE_IDENTIFIER = <value>;" token is
// matched, so an Application id never collides with the Tests ids.
var bundles = []struct {
	stock string
	suf   string
}{
	{"com.example.Application", ""},
	{"com.example.ApplicationTests", ".Tests"},
	{"com.example.ApplicationUITests", ".UITests"},
}

func run(args []string) error {
	fs := flag.NewFlagSet("bundleid", flag.ContinueOnError)
	config := fs.String("config", "build/xcode/config/config.jsonc", "path to the merged Xcode config.jsonc")
	project := fs.String("project", "build/xcode/sources/Application/Application.xcodeproj/project.pbxproj", "path to the Xcode project.pbxproj")
	if err := fs.Parse(args); err != nil {
		return err
	}

	appID, err := readAppID(*config)
	if err != nil {
		return err
	}

	content, err := os.ReadFile(*project)
	if err != nil {
		return err
	}

	patched, err := applyBundleIDs(content, appID)
	if err != nil {
		return err
	}

	if string(content) != string(patched) {
		return os.WriteFile(*project, patched, 0644)
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

// applyBundleIDs rewrites the PRODUCT_BUNDLE_IDENTIFIER values in the pbxproj
// content to match appID. Each market line must appear exactly twice (Debug +
// Release) or, when the file was already patched, the new value must appear
// twice. Any other count means the file was customized and the tool fails
// rather than guess.
func applyBundleIDs(content []byte, appID string) ([]byte, error) {
	if appID == "" {
		return nil, fmt.Errorf("app_id must not be empty")
	}
	out := string(content)
	for _, b := range bundles {
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
```

Note: replace the stub `import` and `run` bodies from Task 1 with the ones
above; keep the stub `fatal` and the license header.

- [ ] **Step 4: Run tests to verify they pass**

Run: `task test` from `tools/bundleid/src`
Expected: PASS (all 6 tests).

- [ ] **Step 5: Format and commit**

```bash
cd tools/bundleid/src && gofmt -w . && git add tools/bundleid && git commit -m "✨ feat(bundleid): rewrite PRODUCT_BUNDLE_IDENTIFIER from app_id"
```

---

### Task 3: Wire into root `Taskfile.yml` and `AGENTS.md`

**Files:**
- Modify: `Taskfile.yml`
- Modify: `AGENTS.md`

**Interfaces:**
- Consumes: built binary `tools/bundleid/dist/bundleid-<os>-<arch>` (built in Task 4; the Taskfile task references it regardless).

- [ ] **Step 1: Add the `bundleid` tasks to `Taskfile.yml`**

Append after the `core.build` block (end of file):

```yaml
  # Bundleid Tool
  bundleid:
    aliases:
      - bid
    desc: Set the Xcode bundle identifiers from the app_id in the merged config
    cmds:
      - "tools/bundleid/dist/bundleid-{{OS}}-{{ARCH}}{{ if eq OS \"windows\" }}.exe{{ end }}"
  bundleid.build:
    aliases:
      - bib
    dir: tools/bundleid/src
    desc: Generate tools/bundleid binary
    cmds:
      - task build
```

- [ ] **Step 2: Add the tasks to `AGENTS.md`**

Under the `## Commands` list, insert after the `task core` entry:

```markdown
- `task bundleid` (alias `bid`): Set the Xcode bundle identifiers from the `app_id` in the merged config.
- `task bundleid.build` (alias `bib`): Generate the `tools/bundleid` binary.
```

- [ ] **Step 3: Format/lint and commit**

Run: `task lint.yaml` (or at least `prettier --write Taskfile.yml AGENTS.md`)
Then:

```bash
git add Taskfile.yml AGENTS.md
git commit -m "✨ feat(bundleid): wire bundleid tasks into Taskfile and AGENTS.md"
```

---

### Task 4: Build and commit dist binaries

**Files:**
- Create: `tools/bundleid/dist/bundleid-darwin-amd64`, `bundleid-darwin-arm64`, `bundleid-linux-amd64`, `bundleid-windows-amd64.exe` (generated)

**Interfaces:**
- Consumes: source from Tasks 1-2.

- [ ] **Step 1: Build the binaries**

Run: `task build` from `tools/bundleid/src`
Expected: 4 binaries in `tools/bundleid/dist/`.

- [ ] **Step 2: Sanity-check on the real files**

```bash
tools/bundleid/dist/bundleid-darwin-arm64 --config build/xcode/config/config.jsonc --project build/xcode/sources/Application/Application.xcodeproj/project.pbxproj
```

Note: `build/` has the default wildcard config (`com.example.*`), so this runs
the literal path end to end. Re-run to confirm it is a no-op (exit 0).

- [ ] **Step 3: Commit**

```bash
git add tools/bundleid/dist
git commit -m "🔧 build(bundleid): add prebuilt bundleid binaries"
```

---

## Self-Review

**Spec coverage:**
- Read `app_id`, empty is an error → `readAppID` (Task 2). ✓
- Patch three targets, two configs each → `bundles` + `applyBundleIDs` (Task 2). ✓
- Literal wildcard → `TestApplyBundleIDsLiteralWildcard`. ✓
- Idempotent, no-op if already patched → `newN == 2` branch + idempotent test. ✓
- Fail loudly on unexpected counts → error branch + missing-marker test. ✓
- CLI flags with given defaults → `run` (Task 2). ✓
- Files/README/Taskfile/VERSION/AGENTS/root Taskfile → Tasks 1, 3. ✓
- dist binaries committed → Task 4. ✓
- Testing conventions (white-box, stdlib only, one integration via `run()`) → main_test.go. ✓

**Placeholders:** none — every step carries concrete content.

**Type consistency:** `readAppID`, `applyBundleIDs`, `run` signatures match across all usages; binary name is `bundleid` everywhere.