# Tools

CLI tools and vendored binaries used by the build pipeline.

## Layout

- `icon/` — Generates Android and Xcode app icons from a single 1024x1024 PNG
  (Go). Prebuilt binaries in `dist/`.
- `jsonc/` — Merges cascading JSONC configuration files (Go). Prebuilt
  binaries in `dist/`.
- `xcode/` — Xcode utility scripts (Swift).
- `vendor/esbuild/` — Vendored esbuild binary for TypeScript bundling.
  Selected per OS and architecture automatically.
- `android/` — Placeholder for Android-specific tooling.

## Building from source

Go tools (`icon`, `jsonc`) can be rebuilt from their `src/` directories:

```
cd <tool>/src
task build    # cross-compile into ../dist/
task test     # run tests
```
