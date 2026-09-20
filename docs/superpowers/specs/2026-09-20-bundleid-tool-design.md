# Design: `tools/bundleid` — First task: bundle identifier

**Date:** 2026-09-20
**Status:** Accepted

## Problem

A new Go tool `tools/bundleid` sets the Xcode bundle identifiers to match the
configured `app_id`. It runs after the `core` tool (which assembles the source
tree into `build/xcode/sources/`). Its first task: read the `app_id` property
from the merged config and rewrite `PRODUCT_BUNDLE_IDENTIFIER` in the assembled
Xcode project to match it.

The merged config lives at `build/xcode/config/config.jsonc` (produced by the
`jsonc` tool; plain JSON). The project file lives at
`build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`.

## Requirements

- Read `app_id` from `build/xcode/config/config.jsonc`. Missing or empty
  `app_id` is an error.
- In
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`,
  set the bundle identifiers of all three targets (Application,
  ApplicationTests, ApplicationUITests), in both Debug and Release configs.
- Values are written literally. A wildcard `app_id` (e.g. the default
  `com.example.*`) is not translated; it is written as-is.
- Must be idempotent: re-running against an already-patched file is a no-op.
  (`core` skips files that already exist in `build/`, so the patched project
  persists across runs.)

## Design

No pbxproj parser and no external dependencies. The pbxproj is the stock
Jasonelle file, so its current bundle ids are known.

### Config parse

`json.Unmarshal` the config into:

```go
var cfg struct {
    AppID string `json:"app_id"`
}
```

### Rewrite

Value-anchored string replacement. Each stock line must appear 0 or 2 times
(Debug + Release):

| Stock value | New value |
| --- | --- |
| `com.example.Application` | `app_id` |
| `com.example.ApplicationTests` | `app_id + ".Tests"` |
| `com.example.ApplicationUITests` | `app_id + ".UITests"` |

Replacement matches the full
`PRODUCT_BUNDLE_IDENTIFIER = <value>;` token, including the trailing `;`, so
`com.example.Application` never collides with `com.example.ApplicationTests`
or `com.example.ApplicationUITests`.

Per target:

- 2 occurrences found — replace both.
- 0 occurrences found — acceptable only if the target's id already equals the
  new value, i.e. there are 2 lines of `PRODUCT_BUNDLE_IDENTIFIER = <new value>;`
  (already patched, so no-op). Otherwise fail loudly: a lib override has
  rewritten the ids and the tool should not guess.

When `app_id` happens to equal the stock value (e.g. `com.example.Application`),
stock and new lines coincide and the target is effectively a no-op.

### CLI

- `--config` (default `build/xcode/config/config.jsonc`)
- `--project` (default
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`)

## Files

- `tools/bundleid/src/main.go`
- `tools/bundleid/src/main_test.go`
- `tools/bundleid/src/go.mod` (module `jasonelle.com/jasonelle/tools/bundleid`)
- `tools/bundleid/src/VERSION` (`1.0.0`)
- `tools/bundleid/src/Taskfile.yml` (build/test/format/version-bump, cross-compiles
  to darwin-amd64/arm64, linux-amd64, windows-amd64)
- `tools/bundleid/src/.gitignore`
- `tools/bundleid/dist/` (git-tracked binaries)
- `tools/bundleid/README.md`
- Root `Taskfile.yml`: `bundleid` (`bid`) and `bundleid.build` (`bib`) tasks
- `AGENTS.md`: document the new tasks

## Testing

White-box `main_test.go`, standard `testing` only:

- unit test for the rewrite function (both configs patched, already-patched
  no-op, missing-marker error)
- one integration test via `run()` against temp files with explicit flags

## Out of scope

- Wildcard translation (treated literally by decision).
- Translating other `app_id` usages (e.g. Android application id).
- Web docs page in `antora/modules/tools/`.