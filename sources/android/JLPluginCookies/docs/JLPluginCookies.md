# JLPluginCookies

A Jasonelle plugin that stores a cookie string in Android encrypted storage and restores it into the web view.

## Overview

JLPluginCookies keeps a single cookie string (e.g. `session=abc; Path=/`) in `EncryptedSharedPreferences` (backed by the Android Keystore via `MasterKey`) so it survives app restarts. JavaScript saves the current web view cookies with `persist()`, stores an explicit string with `save(value)`, and restores them with `restore()`, which also injects the value into the web view's cookies after the DOM has loaded.

### Structure

| File | Role |
|------|------|
| `Plugin.kt` | Native side – saves and reads the cookie string from `EncryptedSharedPreferences`. |
| `Plugin.js` | JavaScript side – registers the plugin on `window.jasonelle.plugins.cookies`. |

### How it works

1. The plugin is injected into the web view on page load and registers itself on `window.jasonelle.plugins.cookies`.
2. `persist()` captures the current cookies with `document.cookie` and stores them in encrypted preferences.
3. `save(value)` stores an explicit cookie string in encrypted preferences.
4. `restore()` reads the string from encrypted preferences and sets it via `document.cookie` once the DOM is loaded, then resolves with the value.

### Response

The promise resolves with an object like:

```json
{
  "status": "ok",
  "value": "session=abc; Path=/"
}
```

`restore()` resolves with an empty `value` when nothing is stored yet.

## Reference

- `com.jasonelle.kernel.Plugin` – the base class this plugin extends.
- `Plugin.js` in `src/main/assets/plugins/cookies/` – the JavaScript client, byte-identical to the Xcode plugin.