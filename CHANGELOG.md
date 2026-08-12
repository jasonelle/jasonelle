# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0] - NEXT

V4 is a complete rewrite of the project, built from scratch with better
documentation and code. It breaks compatibility with previous versions.

### Added

- Antora-based documentation site with a Docker build pipeline.
- Task runner (`go-task`) with `install`, `build`, `serve`, `lint` and
  `commit` tasks.
- GitHub Actions workflows: documentation build and publish, automated SemVer
  pre-releases, and pre-release promotion.
- Dual licensing: AGPL-3.0 by default, MPL-2.0 with a valid activation key.
- `sources/` directory for Android and Xcode projects.
- `tools/` directory for auxiliary binaries and Elixir scripts.
- `VERSION` file and automated SemVer versioning (a `<major>.<minor>` base
  with a timestamp patch).

### Removed

- Old v3 engine and legacy code.

## [3.0.4] - 2026-03-02

### Changed

- iOS: support upgraded to iOS 26+.

## [3.0.3] - 2026-02-10

Last version to support iOS 14.

### Added

- iOS: optional OneSignal extension.
- iOS: `app.json` and Python script to generate `App.xcconfig` (bundle
  identifier, app name, version, build version and other runtime settings).
- iOS: `JLSettings` extension to load `NSBundle.mainBundle.infoDictionary`
  values stored in the `app.settings.value` singleton.
- iOS: progress bar and style option to show the progress bar or launch UI in
  WebViewRendererUI.
- Web: `window.jasonelle.extensions` (or `window.$extensions`) global variable
  to easily access available extension wrappers.
- Web: `window.jasonelle.oem` global variable to quickly determine the system
  (`apple`, `google`, `other`).

## [3.0.2] - 2024-06-26

### Added

- iOS: `$clipboard.set(text)` and `$clipboard.get()` functions.
- iOS: `$device.info()` function.
- iOS: `$contacts.authorize()` function; the extension no longer triggers
  authorization on install.
- iOS: `$audio` extension with `$audio.player`, `$audio.recorder` and
  `$audio.vibrate` functions.
- iOS: `$photolibrary.camera.authorize()` and
  `$photolibrary.camera.granted()` functions; the extension no longer triggers
  authorization on install.
- Core: `make permissions` command to fix "bad interpreter: Operation not
  permitted" errors.
- Core: `example.html` file with examples for the extensions.
- Core: build phase script in the framework project.

### Changed

- Core: improved the way the example HTML file is generated; extensions can
  add their examples at compilation time.

### Fixed

- ARM Macs: automatically detects the processor and selects the proper build
  tool.
- Core: fixed crash when clicking a non-HTML link (now opens
  `SFSafariViewController`).
- Special schema links: `sms`, `tel` and `facetime` schemas now open the
  correct app.

## [3.0.1] - 2023-03-25

### Added

- Extensions can inject JavaScript into the `WKWebView` instance.
- The `WKWebView` instance can load URLs using deep links like
  `jasonelle://href?=https://google.cl`.
- `JLPhotoLibrary` extension to request access to the photo library.
- `$keychain` extension: `$keychain.set`, `$keychain.get`,
  `$keychain.remove`.
- `$cookies` extension: `$cookies.set`, `$cookies.get`, `$cookies.remove`,
  plus the `js-cookie` library via `$cookies.Cookies`.
- `$contacts` extension: `$contacts.all`.
- Ability to configure an allowed list of URLs; non-allowed URLs launch the
  native browser.
- LaunchScreen file (SwiftUI and Storyboard).
- `WebView.edgesIgnoringSafeArea(.all)` setting.
- Meta viewport JavaScript fix for websites without a proper meta tag.
- Example extension.
- Hook triggering and event triggering in the WebView for extensions.
- `Reachability` events extension.

### Fixed

- `WKWebView` triggered the `appdidLoad` event more than once; now it only
  triggers when loaded.
- `build.sh` crashed when using paths with spaces.

## [3.0.0] - 2022-09-27

New engine created from scratch in 2022. It ditched the old JSON based
approach for a JavaScript one. It consists mainly of a WebView engine.

### Added

- Full rewrite of the engine from scratch.
- Focus on the WebView workflow.
- No need for Cocoapods, Carthage or Swift Package Manager.

### Removed

- Native over the wire workflows (delegated to other frameworks).

## Legacy (2016-2022)

Legacy versions using the old engine (MIT License). Not currently supported.

- Android v2: <https://github.com/jasonelle-archive/jasonette-android/archive/refs/heads/develop.zip>

[3.0.0]: https://github.com/jasonelle/jasonelle/releases/tag/v3.0.0
[3.0.1]: https://github.com/jasonelle/jasonelle/releases/tag/v.3.0.1
[3.0.2]: https://github.com/jasonelle/jasonelle/releases/tag/v3.0.2
[3.0.3]: https://github.com/jasonelle/jasonelle/releases/tag/v3.0.3
[3.0.4]: https://github.com/jasonelle/jasonelle/releases/tag/v3.0.4
