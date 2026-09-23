# Xcode (iOS) Project

The iOS source project for Jasonelle. It is a native SwiftUI app that renders a
website inside a `WKWebView` and bridges JavaScript calls to native Swift
plugins through a bidirectional message channel.

## Repository layout

| Path | Contents |
|------|----------|
| `Jasonelle.xcworkspace/` | Xcode workspace that groups the app, the kernel framework and the plugins. |
| `Application/` | The iOS app target. Contains SwiftUI views, resources (`Assets.xcassets`), `config.jsonc`, `webview.js` and the `Application.docc` documentation. |
| `JLKernel/` | A reusable framework consumed by the app: `WebView`, `Coordinator`, `Plugin`, `Events`, `ConfigurationLoader`, `Logger`, `Version` and `License`. |
| `JLPluginHello/` | A sample plugin that demonstrates the native–JavaScript bridge. |
| `JLPluginDevice/` | A plugin that reports device information to JavaScript. |
| `JLPluginCookies/` | A plugin that persists web view cookies in the iOS Keychain. |
| `JLPluginAppleSignIn/` | A plugin that provides Sign in with Apple. |
| `.swiftlint.yml` | SwiftLint rules. |
| `.clang-format` | Formatting rules for C/C++/Objective-C sources. |
| `Taskfile.yml` | `task lint` / `task fix` run SwiftLint. |

## Architecture

Jasonelle iOS follows a layered architecture. The **Application** layer owns the
SwiftUI lifecycle and the registered plugin instances. The **JLKernel** layer
provides the web view, the JavaScript bridge and the message routing. The
**plugins** layer implements native features callable from JavaScript.

### System Context (C4 L1)

```mermaid
C4Context
  title System Context for Jasonelle iOS

  Person(user, "User", "Operates the app on an iPhone or iPad")
  System(app, "Jasonelle iOS App", "Renders a remote website in a WKWebView and bridges JavaScript calls to native plugins")

  System_Ext(web, "Website Content", "The remote website loaded in the web view, e.g. jasonelle.com")
  System_Ext(safari, "Safari", "Opens links and downloads that are not allowed inside the web view")
  System_Ext(apple, "Apple Services", "AuthenticationServices (Sign in with Apple) and the iOS Keychain")

  Rel(user, app, "Uses", "views the website and interacts with plugins")
  Rel(app, web, "Loads and renders", "WKNavigation requests")
  Rel(app, safari, "Opens external links in modal SFSafariViewController", "navigation policy")
  Rel(app, apple, "Stores cookies and authenticates users", "Sign in with Apple / Keychain")
```

### Containers (C4 L2)

```mermaid
C4Container
  title Container Diagram for Jasonelle iOS

  Container_Boundary(app_b, "Application") {
    Container(main, "Main", "SwiftUI App", "Entry point. Prints the logo, verifies the license, registers plugins and sends app events")
    Container(contentView, "ContentView", "SwiftUI View", "Hosts the JLKernel WebView inside a ZStack")
    Container(plugins, "Plugins registry", "Swift", "Instantiates the four plugin modules into a [id: Plugin] dictionary")
  }

  Container_Boundary(kernel_b, "JLKernel") {
    Container(webView, "WebView", "SwiftUI / WKWebView", "Renders the website, injects the JS bridge and plugin scripts")
    Container(coordinator, "Coordinator", "Swift", "Receives JS messages, dispatches calls to plugins, replies to JS and decides the navigation policy")
    Container(basePlugin, "Plugin", "Swift protocol/class", "Base class with handle_call / handle_event and resolve / reject / event helpers")
    Container(events, "Events", "Swift enum", "Broadcasts native lifecycle events to the registered plugins")
    Container(configLoader, "ConfigurationLoader", "Swift", "Reads and decodes config.jsonc (JSONC) into AppConfiguration")
  }

  Container_Boundary(plugins_b, "Plugins") {
    Container(hello, "JLPluginHello", "Swift module", "Demonstrates call + resolve round-trip")
    Container(device, "JLPluginDevice", "Swift module", "Reports device info to JS")
    Container(cookies, "JLPluginCookies", "Swift module", "Stores web view cookies in the Keychain")
    Container(auth, "JLPluginAppleSignIn", "Swift module", "Sign in with Apple flows")
  }

  Rel(main, contentView, "shows")
  Rel(contentView, webView, "renders")
  Rel(main, plugins, "holds")
  Rel(webView, coordinator, "forwards JS messages and navigation events")
  Rel(coordinator, basePlugin, "looks up by id and dispatches")
  Rel(main, events, "broadcasts")
  Rel(webView, configLoader, "loads configuration from bundle")

  UpdateLayoutConfig($c4ShapeInRow = "2", $c4BoundaryInRow = "2")
```

### The JavaScript Bridge

The bridge is a bidirectional message channel between the page loaded in the
`WKWebView` and native code.

- `WebView.jsBridgeScript` is injected at **document start** and defines the
  `window.jasonelle` object with `post(name, args)`, `result.resolve`, `result.reject`
  and `plugin.init`.
- Each plugin's `Plugin.js` is injected at **document end** and registers itself
  on `window.jasonelle.plugins.<name>`.
- JavaScript posts a message to `window.webkit.messageHandlers.jasonelle`.
- The `Coordinator` resolves the message to a plugin and invokes
  `handle_call(callbackId:args:respond:)`; plugins reply through `resolve` or
  `reject`, which evaluate `window.jasonelle.result.resolve|reject(...)` back in
  the page.

```mermaid
sequenceDiagram
  autonumber
  actor JS as Web Page
  participant webview as WKWebView
  participant coord as Coordinator
  participant plugin as Plugin.handle_call
  participant respond as respond(script)

  JS->>JS: plugins.hello.call("Hello", "World")
  JS->>webview: jasonelle.post(id, args) returns Promise (callbackId = uuid)
  webview->>coord: messageHandlers.jasonelle { name, args, callbackId }
  coord->>coord: handleMessage: look up plugin by name in plugins dict
  coord->>plugin: handle_call(callbackId, args, respond)
  plugin->>plugin: build response { status, callbackId, ... }
  plugin->>respond: resolve(args, callbackId, respond)
  respond->>webview: evaluateJavaScript window.jasonelle.result.resolve({...})
  webview->>JS: resolve args.callbackId & delete pending callback
  JS-->>JS: promise .then(response => ...)
```

The message body is a dictionary:

```json
{ "name": "com.jasonelle.plugins.hello", "args": ["Hello", "World"], "callbackId": "<uuid>" }
```

`name` is the **plugin id** (reverse domain notation), which is also the key in
the plugins dictionary registered by the application.

### Script injection order

```mermaid
flowchart TD
  A[makeUIView] --> B[bridge script @ documentStart]
  B --> C[plugin scripts Plugin.js @ documentEnd]
  C --> D[app webview.js @ documentEnd]
  D --> E[load initial URL]
  E --> F[webview.js runs: window.jasonelle.plugins.cookies.restore]
```

### Navigation policy

The app keeps the user inside the web view unless the destination is not
allowed, in which case it opens a modal `SFSafariViewController`.

```mermaid
flowchart TD
  A[WKNavigationAction] --> B{allowed is nil or empty?}
  B -- yes --> C[.allow everything in web view]
  B -- no --> D{host in allowed or host == main URL?}
  D -- yes --> E[.allow in web view]
  D -- no --> F[.cancel + present SFSafariViewController]
  %% main-frame responses the web view cannot render (downloads) also go to Safari
  G[WKNavigationResponse main frame] --> H{canShowMIMEType?}
  H -- yes --> I[.allow]
  H -- no --> F
```

### Native events

Native code notifies all registered plugins about lifecycle events. The app
registers plugins once in `Main.init()` and broadcasts on `ContentView.onAppear`:

```mermaid
sequenceDiagram
  participant main as Main.init
  participant events as JLKernel.Events
  participant p1 as Plugin (cookies)
  participant p2 as Plugin (device)

  main->>main: License.verify(key)
  main->>events: Events.register(plugins:)
  rect rgb(245, 245, 245)
    note over events: ContentView.onAppear
    events->>p1: handle_event("ContentView.onAppear")
    events->>p2: handle_event("ContentView.onAppear")
  end
```

## JLKernel components

| Component | Responsibility |
|-----------|----------------|
| `WebView` | SwiftUI `UIViewRepresentable` that creates the `WKWebView`, registers the message handler, injects the bridge, plugin and app scripts, and applies the navigation delegate. |
| `Coordinator` | `WKNavigationDelegate` + `WKScriptMessageHandler`. Routes JavaScript messages to plugins, executes responses back in the page and applies the navigation policy. `handleMessage(body:)` and `decidePolicy(url:allowed:mainURL:)` are extracted for unit testing. |
| `Plugin` | Base class every plugin subclasses. Provides `name`/`id` defaults, `handle_call`, `handle_event`, the `resolve`/`reject`/`event` helpers and `js()`/`inject(into:)` script injection. |
| `Events` | Enum of native events with a static plugin registry, `register(plugins:)` and `sendOnAppear()`. |
| `ConfigurationLoader` | Loads `config.jsonc` from the app bundle, strips comments (`//` and `/* */`) and decodes it into `AppConfiguration` (`url`, `inspectable`, `allowed`). |
| `Logger` | Structured logging over `os.Logger` with `LogLevel` severities and Ratlog-format output via `Ratlog`. |
| `Version` | Reads the bundled `VERSION` resource and returns the semantic version. |
| `License` | Verifies a Jasonelle license key; aborts on physical devices without a license, logs a reminder in the simulator. |

### Plugins

Each plugin is an independent Swift module (a framework inside the workspace)
that subclasses `JLKernel.Plugin`. Plugins are composed by the **Application**
in `Plugins.swift`, which imports and instantiates them. Keys must match the
plugin id used in JavaScript (`window.jasonelle.plugins.<name>`).

| Plugin | Native API | JS object |
|--------|-----------|-----------|
| `JLPluginHello` | `handle_call` echoes a response | `plugins.hello.call()` |
| `JLPluginDevice` | `handle_call` returns device info | `plugins.device.info()` |
| `JLPluginCookies` | `handle_call` stores/reads cookies in the Keychain | `plugins.cookies.save()`, `restore()`, `persist()` |
| `JLPluginAppleSignIn` | Sign in, credential state and native button via `ASAuthorizationController` | `plugins.applesignin.signIn()`, `getCredentialState()`, `showNativeButton()` |

## Development

- Open `Jasonelle.xcworkspace` in Xcode to build the `Application` scheme.
- Unit tests live in each module's `<Module>Tests` target (`JLKernelTests`,
  `JLPluginHelloTests`, `JLPluginDeviceTests`, `JLPluginCookiesTests`,
  `JLPluginAppleSignInTests`, `ApplicationTests`).
- Run SwiftLint with `task lint` (auto-fix with `task fix`).
- Each module ships a DocC catalog (`*.docc`) describing its public API. Open
  the workspace in Xcode and select "Documentation" in the navigator to browse
  them.