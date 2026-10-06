# ``JLPluginOpenTelemetry``

A Jasonelle plugin that reports information about the opentelemetry running the app.

## Overview

JLPluginOpenTelemetry exposes opentelemetry details to JavaScript. Call it from the web view to learn the operating system, vendor, opentelemetry type, orientation, and screen size.

### Structure

| File | Role |
|------|------|
| `Plugin.swift` | Native side – collects opentelemetry information and responds to calls from JavaScript. |
| `Plugin.js` | JavaScript side – registers the plugin on `window.jasonelle.plugins.opentelemetry`. |

### How it works

1. The plugin is injected into the web view at document end and registers itself on `window.jasonelle.plugins.opentelemetry`.
2. Call `window.jasonelle.plugins.opentelemetry.info()` from JavaScript; it returns a promise.
3. The call is routed to `Plugin.swift` `handle_call(args:callbackId:respond:)`, which resolves the promise with the opentelemetry information.

### Response

The promise resolves with an object like:

```json
{
  "status": "ok",
  "os": { "name": "ios", "version": "18.1" },
  "vendor": "apple",
  "type": "iphone",
  "orientation": "portrait",
  "screen": { "width": 393, "height": 852 }
}
```

`os.name` is `ios`, `macos`, `tvos`, or `watchos` depending on the platform. `type` is `ipad`, `iphone`, or `macos`. `orientation` is a `UIDeviceOrientation` value and only meaningful on iOS.

## Topics

### Essentials

- ``JLPluginOpenTelemetry/Plugin``
