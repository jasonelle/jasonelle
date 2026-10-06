# Fastlane

Generates the standard Ruby Fastlane files (Fastfile, Appfile, Deliverfile,
Supplyfile, Matchfile and localized store metadata) from the merged
`store.jsonc` configs, so developers can run `fastlane release` in the
assembled projects. Run after `task appconf`, against `build/`:

- Reads `build/xcode/config/store.jsonc` and `build/android/config/store.jsonc`.
- Writes the generated files to `build/<platform>/fastlane/`.
- Mirrors that directory into `build/<platform>/sources/fastlane/`, the
  workspace/Gradle root, so lanes run from the project:
  `cd build/android/sources && fastlane release`.

Each lane in the Fastfiles passes the full configured parameter block
(`supply`/`deliver`/`gym`/`match`/`gradle`) as keyword arguments, so store
configuration values map directly to Fastlane parameters.

## Key file handling

Repo-relative path values such as `json_key_file`
(`lib/android/config/play-store-key.json`) and `app_rating_config_path` are
resolved against the working directory. When the file exists it is copied next
to the `Fastfile` and the emitted value is its basename (e.g.
`json_key_file("play-store-key.json")`). When it is missing the value is
emitted verbatim and a warning is printed, so the default configs keep
working.

## Usage

From the repository root:

```
tools/fastlane/dist/fastlane-<os>-<arch>
```

Flags (defaults work against the standard `build/` tree):

- `--xcode-config` (default `build/xcode/config/store.jsonc`)
- `--android-config` (default `build/android/config/store.jsonc`)
- `--xcode-out` (default `build/xcode/fastlane`)
- `--android-out` (default `build/android/fastlane`)
- `--xcode-sources` (default `build/xcode/sources`)
- `--android-sources` (default `build/android/sources`)

## Building from source

From `tools/fastlane/src`:

- `task build` cross-compiles binaries into `tools/fastlane/dist/`
- `task test` runs the test suite