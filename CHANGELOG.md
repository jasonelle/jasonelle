# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0] - NEXT

V4 is a complete rewrite of the project, built from scratch with better
documentation and code. It breaks compatibility with previous versions.

### Added

- Add agent rules and opencode plugins
- Add allowed URLs config and Safari navigation handling
- Add appid and link tools
- Add apple sign in plugin
- Add changelog generation command
- Add command-create and version-bump commands
- Add commit task to Taskfile
- Add cookies plugin and refactor plugin JS bridge
- Add core and plugins tools
- Add device plugin for iOS
- Add Go tool to generate app icons
- Add id field to ADR documents
- Add iOS Application and Core sources
- Add Jasonelle Android app and kernel
- Add JLPluginHello sample plugin for Android and Xcode
- Add license verification system
- Add native events for plugins
- Add native-JS plugin bridge with WKWebView SwiftUI view
- Add plugin system with JS injection
- Add rule-create command
- Add tool to merge JSONC files
- Add version bump tasks
- Added architecture.adoc
- Adopt ADR documents for design decisions
- Bootstrap Xcode projects and plugin system
- Copy built app artifacts into assembled tree
- Generate per-platform icons with --xcode/--android
- Implement bundler tool
- Inject app webview.js after plugin scripts
- Load app configuration from config jsonc
- Migrate to TypeScript and implement esbuild bundler
- Refine allowed-hosts navigation and download to Safari
- Resolve native calls via promise bridge
- Scaffold Go tool structure
- Vendor esbuild for webview JS bundling

### Changed

- Add ADR-0000011 for XcodeGen and supersede ADR-0000009
- Add ADRs for OneSignal and RevenueCat
- Add architecture README with C4 diagrams
- Add architecture README with C4 diagrams
- Add automated semver pre-releases
- Add basic tests
- Add bundler tool documentation
- Add CNAME for jasonelle.com
- Add cross-compiled binaries
- Add design doc for tools/xcode bundle id task
- Add dual-license headers to xcode sources
- Add git.add and git.all tasks
- Add git.pull task
- Add git.push task and rename commit to git.commit
- Add headers to tools and consolidate command
- Add implementation plan and spec guard for empty app id
- Add license headers to tools
- Add lint.yaml task to format and lint YAML files
- Add opsx workflow commands and skills
- Add SwiftLint tooling and fix all lint warnings
- Add TypeScript ADR and esbuild tool page
- Add VERSION file and document it
- Create CNAME
- Delete tags when pruning pre-releases
- Derive Xcode icon sizes from appIconImages
- Document icon generator and add tooling ADRs
- Document plugin API and response format
- Document promise response in plugin js
- Document the Android project layout
- Drop git.add from git.all pipeline
- Drop JL prefix from LogLevel and Plugin types
- Fixed
- Improve overview, diagrams, and directory accuracy
- Mark tools binaries as binary in .gitattributes
- Redesign plugin API with name/id separation and typed helpers
- Remove andrej-karpathy-skill
- Remove unused vendored highlight.js languages
- Remove vendored skills and consolidate opencode commands
- Removed old version code
- Rename json-merger to jsonc
- Rename tool spec from xcode to bundleid
- Replace placeholder tests with plugin registration and call tests
- Untrack xcuserdata files and track gitignore
- Update AGENTS.md commands and directory layout
- Update changelog for ADR documents
- Update changelog for v4.0
- Update flow and fastlane diagrams
- Update icons task alias in AGENTS.md
- Update plugins lookup key from name to id
- Update README to list actual tools and build instructions
- Update v4.0 section from git commits
- Updated website
- Use bundler tool for esbuild tasks
- Vendor skills with lockfile and reorganize commands
- Write commit message to .commit-message file

### Removed

- Establish the overall project structure V4 is built from scratch with better documentation and code It breaks compatibility with previous versions

### Fixed

- Break long bundler commands to fit yamllint line-length
- Improve license check logic and error message
- Remove stale jsDir only, preserve output in scriptsDir

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
