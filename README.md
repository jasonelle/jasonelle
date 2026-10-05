# Jasonelle

Write for the Web. Ship Native.

Jasonelle wraps your web app as a native iOS and Android app, and gives that
app a bidirectional bridge to native plugins. Your web code calls native
features with `window.jasonelle.plugins.<name>`; native code pushes events
back into the page. One set of configuration inputs drives both platforms.

> **Version 4** is a complete rewrite and breaks compatibility with earlier
> versions. See [CHANGELOG.md](CHANGELOG.md).

## Why

- **One codebase.** The UI you already shipped is the UI. Jasonelle adds the
  native shell, not a second rendering layer.
- **Native, one call away.** Device info, cookies, Apple Sign In and
  OpenTelemetry ship as plugins you call from JavaScript.
- **One set of inputs.** `config.jsonc` and `store.jsonc` merge into both the
  Xcode and Gradle projects, including app icons and Fastlane metadata.
- **One plugin, both platforms.** The bridge installs a
  `window.webkit.messageHandlers` shim on Android, so the same `Plugin.js`
  runs unchanged on iOS and Android.

## Quick start

Download the archive from the latest release or from git

```bash
git clone https://github.com/jasonelle/jasonelle.git
cd jasonelle

task gen      # assemble build/<platform>/ from lib/ and your config
```

`task gen` runs the full pipeline — icons, config merge, script bundling,
plugins, sources, linking, app identifiers and Fastlane files. Each file under
`lib/<platform>/sources/` overrides the stock source of the same name.

```
build/xcode/sources/Jasonelle.xcworkspace    # open this in Xcode
build/android/sources/                       # open this in Android Studio
```

To regenerate the documentation site:

```bash
task install  # build the Antora container image
task build.docs
```

### Prerequisites

| Tool | Needed for |
|------|------------|
| [go-task](https://taskfile.dev) | Running the build pipeline |
| Go | Building the tools in `tools/` |
| Docker | Generating the docs site |
| Xcode / Android SDK | Building the assembled apps |

## How the bridge works

JavaScript calls a native plugin, and native code calls back into the page.
Both directions end at the same `Coordinator`:

```
JS  ──▶ window.jasonelle.post(name, args)   ──▶  Coordinator
JS  ◀── window.jasonelle.result.resolve(...)  ◀──  Plugin.handle_call
JS  ◀── window.jasonelle.plugins.x.handle(...) ◀── Plugin.event
```

Native lifecycle events such as `ContentView.onAppear` reach plugins through
`handle_event`. Because they fire before the page has finished loading, the
`Coordinator` buffers native responses and replays them in order once the
document is ready. Details in the kernel docs.

## Repository layout

| Path | Contents |
|------|----------|
| `sources/xcode/` | iOS app: SwiftUI + `WKWebView`, `JLKernel`, plugins |
| `sources/android/` | Android app: Compose + `WebView`, `JLKernel`, plugins |
| `lib/` | Platform overrides layered onto the assembled sources |
| `tools/` | Go CLI tools and vendored binaries used by the pipeline |
| `antora/` | Antora module sources for the documentation site |
| `website/` | The website sources |
| `docs/` | Generated site, committed for GitHub Pages — do not edit by hand |
| `Taskfile.yml` | Build and documentation tasks |
| `AGENTS.md` | Guidelines for AI agents working in this repository |

Each platform has its own `README.md` with detailed architecture.

## Documentation

- Website — <https://jasonelle.com>
- Docs — <https://jasonelle.com/docs>
- Source — <https://github.com/jasonelle/jasonelle>

## Plugins

| Plugin | iOS | Android |
|--------|-----|---------|
| `hello` — sample bridge demo | ✅ | ✅ |
| `cookies` — persist web view cookies | ✅ | ✅ |
| `device` — device information | ✅ | ✅ |
| `appleSignIn` — Sign in with Apple | ✅ | — |
| `opentelemetry` — tracing | ✅ | ✅ |

Adding your own is covered in the
[plugin docs](https://jasonelle.com/docs/xcode/creating-plugins.html).

## License

Dual licensed. Without a Jasonelle Key the project is licensed under the
**AGPL-3.0**. With a valid key it is licensed under the **MPL-2.0** instead.
Copyright © Jasonelle.com and contributors. See [LICENSE.md](LICENSE.md).
