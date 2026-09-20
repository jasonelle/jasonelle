# Appid

Sets the application identifiers of the assembled projects to the `app_id`
from the merged per-platform configs. Run after `task core`, against
`build/`:

- Xcode: rewrites `PRODUCT_BUNDLE_IDENTIFIER` in
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj` for
  the Application (`app_id`), ApplicationTests (`app_id.Tests`) and
  ApplicationUITests (`app_id.UITests`) targets, in both Debug and Release
  configs.
- Android: rewrites `applicationId` in
  `build/android/sources/Application/build.gradle.kts`. The `namespace` is
  left untouched.

Values are written literally. The config default `com.example.*` is not
translated. Re-running is a no-op.

## Usage

From the repository root:

```
tools/appid/dist/appid-<os>-<arch>
```

Flags (defaults work against the standard `build/` tree):

- `--xcode-config` (default `build/xcode/config/config.jsonc`)
- `--xcode-project` (default
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`)
- `--android-config` (default `build/android/config/config.jsonc`)
- `--android-project` (default `build/android/sources/Application/build.gradle.kts`)

## Building from source

From `tools/appid/src`:

- `task build` cross-compiles binaries into `tools/appid/dist/`
- `task test` runs the test suite