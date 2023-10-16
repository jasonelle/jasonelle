# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## v3.0.2 (next)

### Added
- [JLClipboard] Added `$clipboard.set(text)` and `$clipboard.get()` functions. This will allow copy and access text in native clipboard.

- [JLDevice] Added `$device.info()` function. To provide access to native device information.

- [JLContacts] Added `$contacts.authorize()` function. Now the extension would not trigger authorization on install.

- [JLAudio] Added `$audio` extension. It has `$audio.player`, `$audio.recorder` and `$audio.vibrate` functions.

- [JLPhotoLibrary] Added `$photolibrary.camera.authorize()` and `$photolibrary.camera.granted()` functions. The extension no longer triggers authorization on install.

- [Core] Added a _Makefile_ command to fix "bad interpreter: Operation not permitted" errors. This error maybe caused by downloading bash files from untrusted sources. Execute `make permissions` inside `sources/xcode` directory to fix any compilation problems with that issue.

- [Core] Add a `example.html` file. Fill it with the examples for the extension.
- [Core] Add a Build Phase Script in the framework project.

### Changed

- [Core] Improved the way the example html file is generated. Now extensions can add the examples on compilation time.

```bash
NAME="MyExtension"
EXAMPLES_DIR="${PWD}/../../App/Files/Examples"
TEMPLATES_DIR="${EXAMPLES_DIR}/Templates"
SOURCES_DIR="${PWD}/${NAME}"

# Only copy the examples if the examples directory exists
if [ -d "${EXAMPLES_DIR}" ]
then
 cat "${SOURCES_DIR}/examples.html" > "${EXAMPLES_DIR}/${NAME}.example.html"
fi
```

### Fixed

- [ARM Macs]. Automatically detects processor and selects the proper build tool.
- [Core]. Fixed crash when clicking a non html link (now shows _SFSafariViewController_).
- [Special Schema Links]. The app wasn't handling the schemas `sms, tel, facetime` properly. Now it open the correct app.

### Downloads

- [iOS Main Branch](https://github.com/jasonelle/jasonelle/archive/refs/heads/main.zip)

## v3.0.1 (March 2023)

### Added

- Ability for extensions to inject _Javascript_ to the _WKWebView_ instance.

- Ability for the _WKWebView_ instance to load url by using _deep links_ like: `jasonelle://href?=https://google.cl`.

- Added `JLPhotoLibrary` extension that helps requesting access to photo library.

- `$keychain` extension: `$keychain.set`, `$keychain.get`, `$keychain.remove` for usage within the WebView. This will enable storing data securely in the iOS's keychain.

- `$cookies` extension: `$cookies.set`, `$cookies.get`, `$cookies.remove` for usage within the WebView. This will help with storing cookies in the keychain. Requires `$keychain` extension to be enabled. Also you can use `$cookies.Cookies` to access [js-cookie](https://github.com/js-cookie/js-cookie) library.

- `$contacts` extension: `$contacts.all` for usage within the WebView.

- Ability to have `allowed` list of urls in configuration. Not allowed urls will launch native browser.

- Added LaunchScreen file (Both in SwiftUI and Storyboard file).

- Added WebView.edgesIgnoringSafeArea(.all). Some websites need this, specially when using a navbar. Thanks to _@Mättu_ in Telegram for pointing this out.

- Added meta viewport js fix for websites that do not have proper metatag. In webview.js.

- Added example extension.

- Added hook triggering for extensions.

- Added event triggering in webview for extensions.

- Added _Reachability_ Events Extension.

### Fixed

- `WKWebView` triggered `appdidLoad` event more than once. Now it only triggers the event when loaded.

- `build.sh` crashed when using paths with spaces.

### Downloads

- [Github Release](https://github.com/jasonelle/jasonelle/releases/tag/v3.0.1)

## v3.0.0 (September 2022)

This is a new engine created from scratch by [_Camilo_](https://github.com/clsource) in 2022. (AGPLv3 or MPLv2 Licenses). It was ditched the old `json` based approach to a `javascript` one. Consists of mainly a WebView engine, because there are lots of competition of "native over the wire" frameworks, and was better to focus on the Web App market such as Bubble users.

- New rewrite of the engine from scratch.
- Will only focus on webview workflow.
- No need for Cocoapods, Carthage or Swift PM.
- Native over the wire workflows delegated to other frameworks like [Native Live](https://native.live).

### Downloads

- [Github Release](https://github.com/jasonelle/jasonelle/releases/tag/v3.0.0)

## Legacy Versions (2016 - 2022)

These versions are not currently supported, but maybe something can be learned or be useful. These were using the old engine created originally by [_Ethan_](https://github.com/gliechtenstein). (MIT License).

### Downloads

- [Android v2](https://github.com/jasonelle-archive/jasonette-android/archive/refs/heads/develop.zip)

- [iOS v2](https://github.com/jasonelle-archive/jasonette-ios/archive/refs/heads/develop.zip)
