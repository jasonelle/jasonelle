# Tools

CLI tools and vendored binaries used by the build pipeline.

## Layout

- `bundler/` — Bundles TypeScript scripts into a single `webview.js` per
  platform via esbuild (Go). Prebuilt binaries in `dist/`.
- `icon/` — Generates Android and Xcode app icons from a single 1024x1024 PNG
  (Go). Prebuilt binaries in `dist/`.
- `jsonc/` — Merges cascading JSONC configuration files (Go). Prebuilt
  binaries in `dist/`.
- `plugins/` — Copies the plugins listed in the merged configs into
  `build/<platform>/sources/` (Go). Prebuilt binaries in `dist/`.
- `vendor/esbuild/` — Vendored esbuild binary for TypeScript bundling.
  Selected per OS and architecture automatically.

## Building from source

Go tools (`bundler`, `icon`, `jsonc`, `plugins`) can be rebuilt from their `src/` directories:

```
cd <tool>/src
task build    # cross-compile into ../dist/
task test     # run tests
```
