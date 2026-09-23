# Plugins

Copies the plugin directories listed in the merged per-platform `config.jsonc`
files into `build/<platform>/sources/`. Each plugin is declared in the
`plugins` map of the configuration; the value is a path reference that
resolves to the plugin source and tells the tool which platforms it targets.

## Platform filtering

The second path segment selects the platform when present:

- `@jasonelle/JLPluginHello` — Xcode and Android core plugin
  (`sources/xcode/JLPluginHello` and `sources/android/JLPluginHello`).
- `@jasonelle/xcode/JLPluginAppleSignIn` — Xcode-only core plugin.
- `@jasonelle/android/JLPluginFoo` — Android-only core plugin.
- `@lib/JLPluginCustom` — custom plugin for both platforms
  (`lib/common/sources/plugins/JLPluginCustom/xcode` and `/android`).
- `@lib/xcode/JLPluginCustom` / `@lib/android/JLPluginCustom` — platform-specific
  custom plugin.

Plugins that target the other platform are skipped, so running against the
Xcode config ignores `@jasonelle/android/*` and `@lib/android/*` (and the
reverse for Android). By default those entries are also removed from the
config file itself, leaving each `build/<platform>/config/config.jsonc` with
only the plugins that apply to that platform.

## Usage

From `tools/plugins/src`:

```
go run . --xcode build/xcode/config/config.jsonc --android build/android/config/config.jsonc
```

Both flags are required. The destination dirs (`build/xcode/sources/` and
`build/android/sources/`) are cleaned before copying, so plugins removed from
the configuration do not linger.

Pass `--ignore-platform` to keep the other-platform entries in the config
files; they are still skipped when copying.

## Generated files

After copying, the tool regenerates each platform's plugin composition file by
filtering its template through the markers below; the result is written next to
the copied plugin dirs, mirroring the template path:

- `--xcode-template` (default `sources/xcode/Application/Application/Plugins.swift`)
  → `build/xcode/sources/Application/Application/Plugins.swift`
- `--android-template` (default
  `sources/android/Application/src/main/java/com/jasonelle/application/Plugins.kt`)
  → `build/android/sources/Application/src/main/java/com/jasonelle/application/Plugins.kt`

The generated file only references the plugins used for that platform (those
that resolved `ok` in the config), so a plugin pruned from the config is also
pruned from the generated file the next time the tool runs. Generation always
runs, independent of `--ignore-platform`.

## Marker convention

Inside the templates, each plugin block is wrapped in markers:

```
// PLUGIN:<key>
import JLPluginHello
// ENDPLUGIN
```

`<key>` matches the key in the config `plugins` map. A block whose key is used
is kept verbatim (markers stripped); a block whose key is not used has its body
and markers dropped. Non-marker lines pass through unchanged. The tool fails on
unmatched or nested markers and on an unterminated block.

### Plugins without a template block

A used key that has no `// PLUGIN:` block is synthesized instead of failing.
Each platform template carries `EXTRA` markers where the generated lines are
injected (markers with no plugins emit nothing):

- `// PLUGINS.IMPORT.EXTRA` (Xcode): `import <Name>` per plugin.
- `// PLUGINS.INIT.EXTRA` (Xcode): `<Name>.Plugin.id: <Name>.Plugin()` per
  plugin. The name is the resolved plugin name from the reference.
- `// PLUGINS.INIT.EXTRA.VARS` (Android): `val <name> = <pkg>.Plugin(context)`
  per plugin.
- `// PLUGINS.INIT.EXTRA.MAP` (Android): `<name>.id to <name>` per plugin.

The Android lines are read from the plugin's own `Plugin.kt` (copied into
`build/android/sources/<name>/`): the `package` declaration provides the
fully-qualified class and the `override val name` property provides the
variable/JS key. Explicit template blocks always win over synthesis.

A template that lacks its required `EXTRA` markers while a used plugin has no
block still fails, so a plugin can never silently disappear from the generated
file.

## Building from source

From `tools/plugins/src`:

- `task build` cross-compiles binaries into `tools/plugins/dist/`
- `task test` runs the test suite