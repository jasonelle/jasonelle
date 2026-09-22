# Tools

CLI tools and vendored binaries used by the build pipeline.

## Layout

- `bundler/` — Bundles TypeScript scripts into a single `webview.js` per
  platform via esbuild (Go). Prebuilt binaries in `dist/`.
- `icon/` — Generates Android and Xcode app icons from a single 1024x1024 PNG
  (Go). Prebuilt binaries in `dist/`.
- `appconf/` — Sets the Xcode bundle identifiers and Android `applicationId`
  from the `app_id` in the merged configs (Go). Prebuilt binaries in `dist/`.
- `jsonc/` — Merges cascading JSONC configuration files (Go). Prebuilt
  binaries in `dist/`.
- `plugins/` — Copies the plugins listed in the merged configs into
  `build/<platform>/sources/` (Go). Prebuilt binaries in `dist/`.
- `link/` — Links the plugins present in `build/<platform>/sources/` into the
  Xcode workspace, the Xcode Application project frameworks, the Android
  Gradle files, and copies the built `config.jsonc`/`webview.js` into the
  assembled Application tree (Go). Prebuilt binaries in `dist/`.
- `gen/` — Runs the full build pipeline (`icon`, `jsonc`, `bundler`,
  `plugins`, `core`, `link`, `appconf`) as the root Taskfile would, without
  needing `task` installed (Go). Prebuilt binaries in `dist/`.
- `vendor/esbuild/` — Vendored esbuild binary for TypeScript bundling.
  Selected per OS and architecture automatically.

## Building from source

Go tools (`bundler`, `icon`, `appconf`, `jsonc`, `plugins`, `link`, `gen`) can be rebuilt from their `src/` directories:

```
cd <tool>/src
task build    # cross-compile into ../dist/
task test     # run tests
```
