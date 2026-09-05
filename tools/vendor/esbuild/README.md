# esbuild

Vendored https://esbuild.github.io/[esbuild] binaries, a fast JavaScript
bundler and minifier. Jasonelle uses it to bundle the webview JavaScript into
a single minified file (see ADR
`0000006-use-esbuild-to-bundle-js-files-for-the-webview`).

## Binaries

`dist/` contains the compiled binary for each platform, named
`esbuild-<os>-<arch>` (Windows uses `.exe`):

- `esbuild-darwin-arm64` (macOS arm64)
- `esbuild-darwin-amd64` (macOS x64)
- `esbuild-linux-amd64` (Linux x64)
- `esbuild-windows-amd64.exe` (Windows x64)

## Update

From `src/`:

```sh
task install
```

Downloads the version pinned in `src/Taskfile.yml` (`ESBUILD_VERSION`) from the
npm registry and regenerates the binaries in `dist/`.
