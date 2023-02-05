# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## v3.0.1 (next)

### Added

- Ability for extensions to inject _Javascript_ to the _WKWebView_ instance.

- Ability for the _WKWebView_ instance to load url by using _deep links_ like: `jasonelle://href?=https://google.cl`.

- Added `JLPhotoLibrary` extension that helps requesting access to photo library.

- `$keychain` extension: `$keychain.set`, `$keychain.get`, `$keychain.remove` for usage within the WebView. This will enable storing data securely in the iOS's keychain.

- `$cookies` extension: `$cookies.set`, `$cookies.get`, `$cookies.remove` for usage within the WebView. This will help with storing cookies in the keychain. Requires `$keychain` extension to be enabled. Also you can use `$cookies.Cookies` to access [js-cookie](https://github.com/js-cookie/js-cookie) library.

- `$contacts` extension: `$contacts.all` for usage within the WebView.

### Fixed

- `WKWebView` triggered `appdidLoad` event more than once. Now it only triggers the event when loaded.

### Downloads

- [iOS Main Branch](https://github.com/jasonelle/jasonelle/archive/refs/heads/main.zip)

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