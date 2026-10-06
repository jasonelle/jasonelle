# Android Project

The Android source project for Jasonelle. It is a native Kotlin app (Jetpack
Compose) that renders a website inside a `WebView` and bridges JavaScript calls
to native Kotlin plugins through a bidirectional message channel, mirroring the
iOS (Xcode) implementation.

## Repository layout

| Path | Contents |
|------|----------|
| `gradlew`, `gradle/` | Gradle wrapper used to build every module. |
| `settings.gradle.kts` | Declares the modules: `:Application`, `:JLKernel` and the three plugins. |
| `Application/` | The Android app module. Contains the Compose `MainActivity`, `ContentView`, the plugin registry, assets (`config.jsonc`, `webview.js`) and the `AndroidManifest.xml`. |
| `JLKernel/` | The core library: `JasonelleWebView`, `Coordinator`, `JasonelleBridge`, `Plugin`, `Events`, `ConfigurationLoader`, `Logger`, `Version` and `License`. |
| `JLPluginHello/` | A sample plugin that demonstrates the native–JavaScript bridge. |
| `JLPluginDevice/` | A plugin that reports device information to JavaScript. |
| `JLPluginCookies/` | A plugin that persists web view cookies in encrypted storage. |
| `local.properties` | Local SDK path (gitignored, not committed). |
| `Taskfile.yml` | `task build`, `task test`, `task assemble`, `task lint` wrap the Gradle tasks. |

## Architecture

Jasonelle Android follows the same layered architecture as the iOS project. The
**Application** module owns the activity lifecycle and the registered plugin
instances. The **JLKernel** module provides the web view, the JavaScript bridge
and the message routing. The **plugins** modules implement native features
callable from JavaScript.

### System Context (C4 L1)

```mermaid
C4Context
  title System Context for Jasonelle Android

  Person(user, "User", "Operates the app on an Android phone or tablet")
  System(app, "Jasonelle Android App", "Renders a remote website in a WebView and bridges JavaScript calls to native plugins")

  System_Ext(web, "Website Content", "The remote website loaded in the web view, e.g. jasonelle.com")
  System_Ext(browser, "Mobile Browser", "Opens links and downloads that are not allowed inside the web view (Chrome Custom Tabs)")
  System_Ext(android, "Android Platform", "Android Keystore and encrypted storage for cookies")

  Rel(user, app, "Uses", "views the website and interacts with plugins")
  Rel(app, web, "Loads and renders", "WebView requests")
  Rel(app, browser, "Opens external links in Chrome Custom Tabs", "navigation policy")
  Rel(app, android, "Stores cookies encrypted", "EncryptedSharedPreferences / Keystore")
```

### Containers (C4 L2)

```mermaid
C4Container
  title Container Diagram for Jasonelle Android

  Container_Boundary(app_b, "Application") {
    Container(main, "MainActivity", "Kotlin / Compose", "Entry point. Prints the logo, verifies the license, registers plugins and sets the Compose content")
    Container(contentView, "ContentView", "Composable", "Loads the configuration and hosts the JasonelleWebView inside a Surface")
    Container(plugins, "Plugins registry", "Kotlin", "Instantiates the three plugin modules into a [id: Plugin] map")
  }

  Container_Boundary(kernel_b, "JLKernel") {
    Container(webView, "JasonelleWebView", "Kotlin / WebView", "Renders the website and bridges window.jasonelleBridge to the Coordinator")
    Container(coordinator, "Coordinator", "Kotlin", "Receives JS messages, dispatches calls to plugins, replies to JS and decides the navigation policy")
    Container(bridge, "JasonelleBridge", "Kotlin object", "JS_BRIDGE_SCRIPT injected into the page and JAVASCRIPT_INTERFACE_NAME binding")
    Container(basePlugin, "Plugin", "Kotlin base class", "Base class with handle_call / handle_event and resolve / reject / event helpers")
    Container(events, "Events", "Kotlin enum", "Broadcasts native lifecycle events to the registered plugins")
    Container(configLoader, "ConfigurationLoader", "Kotlin object", "Reads and decodes config.jsonc (JSONC) from app assets into AppConfiguration")
  }

  Container_Boundary(plugins_b, "Plugins") {
    Container(hello, "JLPluginHello", "Kotlin module", "Demonstrates call + resolve round-trip")
    Container(device, "JLPluginDevice", "Kotlin module", "Reports device info to JS")
    Container(cookies, "JLPluginCookies", "Kotlin module", "Stores web view cookies in EncryptedSharedPreferences")
  }

  Rel(main, contentView, "setContent")
  Rel(contentView, webView, "renders")
  Rel(main, plugins, "creates")
  Rel(webView, coordinator, "forwards JS strings from the bridge interface")
  Rel(coordinator, basePlugin, "looks up by id and dispatches")
  Rel(main, events, "registers and broadcasts")
  Rel(contentView, configLoader, "loads configuration from assets")

  UpdateLayoutConfig($c4ShapeInRow = "2", $c4BoundaryInRow = "2")
```

### The JavaScript Bridge

The bridge is a bidirectional message channel between the page loaded in the
`WebView` and native code.

- The native side registers the `Coordinator` as a JavaScript interface named
  `jasonelleBridge` with `addJavascriptInterface`.
- `JasonelleBridge.JS_BRIDGE_SCRIPT` defines `window.jasonelle` with
  `post(name, args)`, `result.resolve`, `result.reject` and `plugin.init`.
- Each plugin's `Plugin.js` registers itself on
  `window.jasonelle.plugins.<name>`.
- `post` stringifies `{ name, args, callbackId }` and calls
  `window.jasonelleBridge.postMessage(json)`.
- The `Coordinator.postMessage` (`@JavascriptInterface`) parses the JSON, looks
  up the plugin and invokes `handle_call(callbackId, args, respond)`. Plugins
  reply through `resolve` or `reject`, which evaluate
  `window.jasonelle.result.resolve|reject(...)` back in the page on the main
  thread.

Because the bridge script also installs a `window.webkit.messageHandlers.*`
shim, the same `Plugin.js` files work unchanged on Android and iOS.

```mermaid
sequenceDiagram
  autonumber
  actor JS as Web Page
  participant webview as WebView
  participant coord as Coordinator.postMessage
  participant plugin as Plugin.handle_call
  participant respond as respondToJS

  JS->>JS: plugins.hello.call("Hello", "World")
  JS->>webview: jasonelle.post(id, args) returns Promise (callbackId = uuid)
  webview->>coord: jasonelleBridge.postMessage("{ name, args, callbackId }")
  coord->>coord: parse JSON, look up plugin by name in plugins map
  coord->>plugin: handle_call(callbackId, args, respond)
  plugin->>plugin: build response { status, callbackId, ... }
  plugin->>respond: resolve(args, callbackId, respond)
  respond->>webview: evaluateJavascript window.jasonelle.result.resolve({...})
  webview->>JS: resolve args.callbackId & delete pending callback
  JS-->>JS: promise .then(response => ...)
```

The message body (JSON stringified by `post`) is:

```json
{ "name": "com.jasonelle.plugins.hello", "args": ["Hello", "World"], "callbackId": "<uuid>" }
```

`name` is the **plugin id** (reverse domain notation), which is also the key in
the plugins map registered by the application.

### Script injection

Android WebView has no document-start/end user scripts, so the bridge, plugin
and app scripts are all evaluated from `onPageFinished`, in the same order as
iOS injects them. The `jasonelleBridge` native interface is available before
the first load, so early page code can still call it.

```mermaid
flowchart TD
  A[createJasonelleWebView] --> B[addJavascriptInterface jasonelleBridge]
  B --> C[load initial URL]
  C --> D[onPageFinished]
  D --> E[inject bridge script window.jasonelle]
  E --> F[inject plugin scripts Plugin.js]
  F --> G[inject app webview.js]
  G --> H[webview.js runs: window.jasonelle.plugins.cookies.restore]
```

### Navigation policy

The app keeps the user inside the web view unless the destination is not
allowed, in which case it opens Chrome Custom Tabs (falling back to a browser
intent). Downloads are also handed to Custom Tabs.

```mermaid
flowchart TD
  A[shouldOverrideUrlLoading] --> B{allowed is nil or empty?}
  B -- yes --> C[return false: load in web view]
  B -- no --> D{host in allowed or host == main URL?}
  D -- yes --> E[return false: load in web view]
  D -- no --> F[return true + open Chrome Custom Tabs]
  G[setDownloadListener] --> H{download URL?}
  H --> F
```

### Native events

Native code notifies all registered plugins about lifecycle events. The app
registers plugins in `MainActivity.onCreate` and broadcasts when the
`ContentView` first appears:

```mermaid
sequenceDiagram
  participant main as MainActivity.onCreate
  participant events as JLKernel.Events
  participant p1 as Plugin (cookies)
  participant p2 as Plugin (device)

  main->>main: License.verify("PURCHASE_ME")
  main->>events: Events.register(createPlugins(...))
  main->>main: setContent { ContentView() }
  rect rgb(245, 245, 245)
    note over events: ContentView LaunchedEffect
    events->>p1: handle_event("ContentView.onAppear")
    events->>p2: handle_event("ContentView.onAppear")
  end
```

## JLKernel components

| Component | Responsibility |
|-----------|----------------|
| `JasonelleWebView` | Compose composable built on `AndroidView`; creates the `WebView` via `createJasonelleWebView` and loads the configured URL. |
| `Coordinator` | `@JavascriptInterface` receiver for JS messages, plus the navigation policy. `handleMessage` and `decidePolicyForHost` are extracted for JVM unit testing. |
| `JasonelleBridge` | Holds `JS_BRIDGE_SCRIPT` (injected into the page) and the interface name `jasonelleBridge`. |
| `Plugin` | Base class every plugin subclasses. Provides `name`/`id` defaults, `handle_call`, `handle_event`, the `resolve`/`reject`/`event` helpers and the `js()` loader that reads `plugins/<name>/Plugin.js` from assets. |
| `Events` | Enum of native events with a static plugin registry, `register(plugins:)` and `sendOnAppear()`. |
| `ConfigurationLoader` | Loads `config.jsonc` from app assets, strips comments (`//` and `/* */`) and decodes it into `AppConfiguration` (`urlString`, `inspectable`, `allowed`). |
| `Logger` | Structured logging with `LogLevel` severities and Ratlog-format output via `Ratlog`. |
| `Version` | Reads the bundled `VERSION` resource and returns the semantic version. |
| `License` | Verifies a Jasonelle license key. |

### Plugins

Each plugin is an independent Gradle module that subclasses `JLKernel.Plugin`
(imported as `KernelPlugin` to avoid the class-name clash). Plugins are
composed by the **Application** in `Plugins.kt`, which instantiates them; the
Cookies plugin receives the application `Context`. Keys must match the plugin
id used in JavaScript (`window.jasonelle.plugins.<name>`).

| Plugin | Native API | JS object |
|--------|-----------|-----------|
| `JLPluginHello` | `handle_call` echoes a response | `plugins.hello.call()` |
| `JLPluginDevice` | `handle_call` returns device info | `plugins.device.info()` |
| `JLPluginCookies` | `handle_call` stores/reads cookies in `EncryptedSharedPreferences` | `plugins.cookies.save()`, `restore()`, `persist()` |

## Development

- Build all modules with `task build` (`./gradlew assembleDebug`).
- Run `task test` (`./gradlew test`) for the JVM unit tests in every module
  (`JLKernelTests`, `JLPluginHelloTests`, `JLPluginDeviceTests`,
  `JLPluginCookiesTests`).
- Build just the app APK with `task assemble`
  (`./gradlew :Application:assembleDebug`), output in
  `Application/build/outputs/apk/debug/`.
- Run lint with `task lint`.
- Every plugin ships a `docs/<Plugin>.md` file describing its native code and
  JavaScript bridge.