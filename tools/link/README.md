# Link

Links the plugins present in the assembled source trees into the native
projects. Run it after `task plugins` and `task core`, before `task appid`:

```
task jsonc
task bundler
task plugins
task core
task link
task appid
```

The tool scans `build/<platform>/sources/` for top-level `JLPlugin*`
directories (the ones the plugins tool copied, minus the other-platform
entries). Plugins added to the config appear on disk and get linked; plugins
removed from the config leave no directory and get unlinked. Anything the core
tool copied that is not a linked plugin — `Application`, `JLKernel`,
non-`JLPlugin` projects — is left untouched.

## Xcode

`build/xcode/sources/`:

- `Jasonelle.xcworkspace/contents.xcworkspacedata` — adds a FileRef
  (`group:<Plugin>/<Plugin>.xcodeproj`) per plugin, removes the stale ones.
- `Application/Application.xcodeproj/project.pbxproj` — adds a
  `PBXBuildFile`/`PBXFileReference` pair per plugin with deterministic 24-hex
  object IDs, plus the Frameworks build phase entry and the Frameworks group
  child, and removes the corresponding stale entries. The framework product is
  assumed to be `<Plugin>.framework` (the convention every core and `@lib`
  plugin follows).

## Android

- `settings.gradle.kts` — the `include(":Plugin")` lines.
- `Application/build.gradle.kts` — the `implementation(project(":Plugin"))`
  lines inside the `dependencies` block.

## Usage

From `tools/link/src`:

```
go run . --xcode-sources build/xcode/sources --android-sources build/android/sources
```

Both flags default to those paths. A rerun is a no-op: every edit is
byte-stable.

## Building from source

From `tools/link/src`:

- `task build` cross-compiles binaries into `tools/link/dist/`
- `task test` runs the test suite