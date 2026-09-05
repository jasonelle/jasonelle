---
description: Creates a new golang tool inside tools/ directory with coding standards for Go tools in this repository. Use when creating, modifying, or reviewing Go projects under tools/. Covers directory layout, module naming, testing, cross-compilation, and conventions derived from tools/icon.
---

# Go Project Structure

Standards for Go tools in `tools/`. Derived from `tools/icon`.

## Directory Layout

```
tools/<name>/
  src/           # Go source (package main)
  dist/          # Prebuilt binaries, one per platform
  references/    # External docs (optional)
  README.md      # Usage, build, version info
```

- `src/` contains all Go source files, `go.mod`, `go.sum`, `Taskfile.yml`, `VERSION`, and a `.gitignore`.
- `dist/` is git-tracked and holds prebuilt binaries. Never hand-edit.
- `references/` holds reference docs for external APIs the tool wraps.

## Module Naming

```
module jasonelle.com/jasonelle/tools/<name>
```

Always fully-qualified under `jasonelle.com/jasonelle/tools/`.

## Source Files

- **Single entry point:** `src/main.go` with `package main`.
- **Test file:** `src/main_test.go`, same package, tests at the package level.
- One file per tool is fine. Split into multiple files only when a single file becomes unwieldy (>300 lines).
- Types, constants, and helpers live in `main.go` alongside the functions that use them. No premature file splitting.

## `main()` Pattern

```go
func main() {
    if err := run(os.Args[1:]); err != nil {
        fatal(err)
    }
}
```

- `main()` delegates to `run([]string) error` for testability.
- `fatal()` prints to stderr and exits with code 1.
- CLI flags parsed inside `run()` via `flag.NewFlagSet`, never at package level.

## Error Handling

- Return errors, don't panic.
- `fatal()` is the only `os.Exit` call site.
- Propagate errors with `if err != nil { return err }`.

## Testing

- Tests in `src/main_test.go`, same package (white-box).
- Use `t.TempDir()` for filesystem tests. Clean up is automatic.
- Test the public surface: `run()`, exported helpers.
- No external test frameworks. Standard `testing` package only.
- One `TestResize`-style unit test per core function; one integration test via `run()`.

## Cross-Compilation

Via `Taskfile.yml` in `src/`:

```yaml
GOOS=darwin GOARCH=amd64 go build -o ../dist/<name>-darwin-amd64 .
GOOS=darwin GOARCH=arm64 go build -o ../dist/<name>-darwin-arm64 .
GOOS=linux  GOARCH=amd64 go build -o ../dist/<name>-linux-amd64 .
GOOS=windows GOARCH=amd64 go build -o ../dist/<name>-windows-amd64.exe .
```

- Output goes to `../dist/`.
- Binary naming: `<name>-<os>-<arch>` (`.exe` suffix for Windows).

## Version

- Plain `VERSION` file in `src/`, SemVer format (`1.0.0`).
- Bump via Taskfile tasks (`version.major`, `version.minor`, `version.patch`).

## File Header

```go
//  main.go
//  tools/<name>
//
//  Created by <author> on <date>
//
//  Copyright (c) Jasonelle
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  ...
```

Use the full dual-license header (AGPLv3 + MPLv2) on every `.go` file.
Check @.opencode/command/append-license.md for more information about license.

## Conventions

- No `init()` functions.
- Struct fields exported only if they cross package boundaries or need JSON tags.
- Prefer `fmt.Fprintf(os.Stderr, ...)` over `log.Fatal` for user-facing errors.
- `defer f.Close()` immediately after a successful `os.Open` or `os.Create`.
- `os.MkdirAll(filepath.Dir(path), 0755)` before writing files to arbitrary paths.
