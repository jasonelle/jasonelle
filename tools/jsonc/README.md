# JSONC Merger

Go tool that deep-merges multiple JSONC files into a single JSONC file. The
first file is the base and each subsequent file overrides it, cascading style.

## Requirements

- [Go](https://go.dev) 1.26 or newer (only for compilation. `dist/` directory contains binaries).
- [go-task](https://taskfile.dev) (optional, only for the tasks below).

## Usage

From `tools/jsonc/src`:

```sh
go run . --output out.jsonc base.jsonc override1.jsonc override2.jsonc
```

`-output` and at least one input file are required. The first input is the base
file. Each following file is deep-merged over the previous one, so later files
win on conflicts.

## Merge semantics

- Nested objects merge recursively.
- Arrays and scalar values are replaced wholesale by later files.
- JSONC comments (`//` and `/* */`) and trailing commas are allowed in the
  inputs and stripped during parsing. The output is plain JSON (which is valid
  JSONC) with 2-space indentation.

## Tasks

From the repository root:

- `task jsonc.build` (`jb`): build the `tools/jsonc` binary.
- `task jsonc` (`j`): merge `lib/common/config/config.jsonc` (base) with
  `lib/xcode/config/config.jsonc` (overrides) into `build/xcode/config.jsonc`.

From `tools/jsonc/src`:

- `task build` (`b`): cross-compile binaries into `../dist/` for macOS
  (amd64/arm64), Linux (amd64) and Windows (amd64).
- `task test` (`t`): run the test suite.

## Release binaries

`dist/` contains prebuilt binaries for each platform, named
`jsonc-<os>-<arch>` (Windows uses `.exe`).

## Version

Edit `src/VERSION` for the current version of the tool using SemVer.

## More Info

- Check `antora/modules/tools/pages/jsonc.adoc`
