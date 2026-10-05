# JLPluginOpenTelemetry

A Jasonelle plugin that wraps the OpenTelemetry SDK to track application metrics.

## Overview

JLPluginOpenTelemetry exposes the OpenTelemetry meter API to JavaScript. Record counters and
histograms on any meter from the web view, and let the SDK exporter ship them to your backend.

### Structure

| File | Role |
|------|------|
| `Plugin.kt` | Native side – connects to `GlobalOpenTelemetry` and records the requested metric. |
| `Plugin.js` | JavaScript side – registers the plugin on `window.jasonelle.plugins.opentelemetry`. |

### How it works

1. The plugin is injected into the web view on page load and registers itself on
   `window.jasonelle.plugins.opentelemetry`.
2. Call `counter()` or `histogram()` from JavaScript; each returns a promise.
3. The call is routed to `Plugin.kt` `handle_call(callbackId:args:respond:)`, which builds the
   instrument on the requested meter and records the value.
4. The promise resolves with `{ "status": "ok", "success": true }`.

The app is responsible for initializing the OpenTelemetry SDK before the first call. Without an
SDK registered, `GlobalOpenTelemetry` falls back to a no-op and discards the values.

### Examples

```javascript
// Increment a counter
await window.jasonelle.plugins.opentelemetry.counter("button_clicks", 1);

// Record a histogram value on a custom meter
await window.jasonelle.plugins.opentelemetry.histogram("load_time_ms", 124.5, "my.meter");
```

Both functions accept an optional third `meterName` argument, defaulting to
`jasonelle.app.meter`.

### Arguments

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `name` | string | yes | Instrument name. If missing, the value is discarded. |
| `value` | number | yes | Value to add to the counter or record in the histogram. |

A call without an `action` of `counter.add` or `histogram.record` rejects with
`status: "error"` and an `error` message.

## Reference

- `com.jasonelle.kernel.Plugin` – the base class this plugin extends.
- `Plugin.js` in `src/main/assets/plugins/opentelemetry/` – the JavaScript client, byte-identical to the Xcode plugin.
