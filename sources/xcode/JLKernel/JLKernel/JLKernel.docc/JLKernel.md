# ``JLKernel``

The core framework for Jasonelle iOS apps.

## Overview

JLKernel provides the runtime backbone for Jasonelle applications. It bundles a SwiftUI ``WebView`` backed by `WKWebView` with a bidirectional JavaScript bridge, a plugin system for native extensions, native ``Events`` that plugins can listen to, structured logging via ``Logger``, semantic ``Version`` reading, and ``License`` verification.

A typical app creates a ``WebView`` with a dictionary of ``Plugin`` instances. JavaScript code communicates with native plugins through `window.jasonelle.post(name, args)`, and plugins respond by executing JavaScript back in the web view. Native code communicates with plugins through ``Events``.

### Quick Start

```swift
import JLKernel

struct ContentView: View {
    var body: some View {
        JLKernel.WebView(
            url: URL(string: "https://example.com")!,
            plugins: ["myplugin": MyPlugin()]
        )
    }
}
```

### How the Bridge Works

1. The ``WebView`` injects a `window.jasonelle` JavaScript object at document start.
2. JavaScript calls `window.jasonelle.plugins.<name>.call(args)`, which posts a message to the native side via `webkit.messageHandlers`.
3. The ``Coordinator`` receives the message, looks up the ``Plugin`` by name, and invokes its ``Plugin/handle_call(args:respond:)`` method.
4. The plugin calls `respond(script)` to execute JavaScript back in the web view.

### Native Events

Native code can notify plugins about app lifecycle events. The app registers its ``Plugin`` dictionary once with ``Events/register(plugins:)`` (e.g. in `Main.init()`), then broadcasts an event with ``Events/sendOnAppear()``. Every registered plugin receives it through `handle_event(name:args:respond:)`, with the event name given by the raw value of the ``Events`` case.

## Topics

### Core

- ``Kernel``
- ``WebView``
- ``Coordinator``

### Plugin System

- ``Plugin``
- ``Events``

### Logging

- ``Logger``
- ``LogLevel``
- ``Ratlog``

### App Infrastructure

- ``Version``
- ``License``