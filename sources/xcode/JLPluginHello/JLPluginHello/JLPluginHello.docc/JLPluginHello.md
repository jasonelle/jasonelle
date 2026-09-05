# ``JLPluginHello``

A sample Jasonelle plugin that demonstrates the native–JavaScript bridge.

## Overview

JLPluginHello is the simplest working plugin for Jasonelle. It shows how to:

- Subclass ``JLKernel/Plugin`` and override its native handler.
- Register a JavaScript object on `window.jasonelle.plugins.*`.
- Call native code from JavaScript and receive a response back in the web view.

### Structure

| File | Role |
|------|------|
| `Plugin.swift` | Native side – handles calls from JavaScript. |
| `Plugin.js` | JavaScript side – registers the plugin, injects a button, and calls the native handler. |

### How it works

1. The plugin is injected into the web view at document end.
2. `Plugin.js` creates a "Click Me" button and prepends it to the DOM.
3. Clicking the button calls `window.jasonelle.plugins.hello.call("Hello", "World")`.
4. The call is routed to `Plugin.swift` `call(args:respond:)`, which responds by executing a JavaScript handler in the web view.

## Topics

### Essentials

- ``JLPluginHello/Plugin``
