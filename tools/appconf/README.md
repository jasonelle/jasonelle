# Appconf

Sets the application identifiers and display names of the assembled projects
from the merged per-platform configs. Run after `task core`, against `build/`:

- Xcode: rewrites `PRODUCT_BUNDLE_IDENTIFIER` in
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj` for
  the Application (`app_id`), ApplicationTests (`app_id.Tests`) and
  ApplicationUITests (`app_id.UITests`) targets, in both Debug and Release
  configs. Also sets `INFOPLIST_KEY_CFBundleDisplayName` on the Application
  target to `app_name`; `PRODUCT_NAME` stays `$(TARGET_NAME)` so the bundle
  keeps the name `Application.app` in the test host paths.
- Android: rewrites `applicationId` in
  `build/android/sources/Application/build.gradle.kts`. The `namespace` is
  left untouched. Also rewrites `android:label` in
  `build/android/sources/Application/src/main/AndroidManifest.xml` to
  `app_name`.

Values are written literally. The config default `com.example.*` is not
translated. Re-running is a no-op. A missing or empty `app_name` leaves the
app name untouched (only identifiers are set).

## Usage

From the repository root:

```
tools/appconf/dist/appconf-<os>-<arch>
```

Flags (defaults work against the standard `build/` tree):

- `--xcode-config` (default `build/xcode/config/config.jsonc`)
- `--xcode-project` (default
  `build/xcode/sources/Application/Application.xcodeproj/project.pbxproj`)
- `--android-config` (default `build/android/config/config.jsonc`)
- `--android-project` (default `build/android/sources/Application/build.gradle.kts`)
- `--android-manifest` (default `build/android/sources/Application/src/main/AndroidManifest.xml`)

## Building from source

From `tools/appconf/src`:

- `task build` cross-compiles binaries into `tools/appconf/dist/`
- `task test` runs the test suite