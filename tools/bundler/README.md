# Bundler

Go tool that bundles TypeScript scripts into a single `webview.js` via the
vendored esbuild binary, for each platform (Android and Xcode). Replaces the
shell-based esbuild tasks with a cross-platform binary that works on macOS,
Linux, and Windows.

## Requirements

- [Go](https://go.dev) 1.26 or newer (only for compilation. `dist/` directory contains binaries).
- [go-task](https://taskfile.dev) (optional, only for the tasks below).
- esbuild (provided by `task bundler.esbuild.install`).

## Usage

From `tools/bundler/src`:

```sh
go run . --platform android \
  --common lib/common/scripts \
  --platform-dir lib/android/scripts \
  --esbuild tools/vendor/esbuild/dist/esbuild-$(go env GOOS)-$(go env GOARCH) \
  --tsconfig lib/common/config/bundler.json \
  --output build/android/scripts/webview.js
```

`--platform`, `--common`, `--platform-dir`, `--esbuild`, and `--output` are
required. `--platform` must be `android` or `xcode`.

Optional flags:

- `--tsconfig`: path to TypeScript config. Default: `lib/common/config/bundler.json`.
- `--target`: esbuild target. Default: `safari11`.
- `--banner`: banner comment prepended to the output. Default: a
  `/*--automatically-generated-by-esbuild-jasonelle--*/` comment.

## How it works

1. Creates staging dirs at `build/<platform>/js` and `build/<platform>/scripts`.
2. Copies common scripts into the staging scripts dir.
3. Copies platform-specific scripts on top (overrides common files with the
   same name).
4. Invokes the vendored esbuild binary with `--bundle --analyze` to bundle
   `main.ts` into `build/<platform>/js/main.js`.
5. Moves the result to `--output`.
6. Cleans up the staging directories.

No shell commands are used; all file operations go through Go's `os` and
`filepath` packages, so it is cross-platform.

## Script structure

```
lib/common/scripts/       # shared TypeScript, included in both platforms
lib/android/scripts/      # Android overrides (copied over common)
lib/xcode/scripts/        # Xcode overrides (copied over common)
```

## Output

- Xcode: `build/xcode/scripts/webview.js`
- Android: `build/android/scripts/webview.js`

A banner comment marks the file as auto-generated.

## Tasks

From the repository root:

- `task bundler` (`bn`): bundle scripts for both Xcode and Android.
- `task bundler.xcode` (`bx`): bundle scripts for Xcode only.
- `task bundler.android` (`ba`): bundle scripts for Android only.
- `task bundler.build` (`bb`): build the `tools/bundler` binary.
- `task bundler.esbuild.install` (`bi`): install the vendored esbuild binary (Unix only).

From `tools/bundler/src`:

- `task build` (`b`): cross-compile binaries into `../dist/` for macOS
  (amd64/arm64), Linux (amd64) and Windows (amd64).
- `task test` (`t`): run the test suite.

## Release binaries

`dist/` contains prebuilt binaries for each platform, named
`bundler-<os>-<arch>` (Windows uses `.exe`).

## Version

Edit `src/VERSION` for the current version of the tool using SemVer.

## More Info

- Check `antora/modules/tools/pages/bundler.adoc`