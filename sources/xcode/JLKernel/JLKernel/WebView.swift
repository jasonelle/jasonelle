//
//  JLWebView.swift
//  JLKernel
//
//  Created by Camilo on 23-08-26.
//

import SafariServices
import SwiftUI
import WebKit

// MARK: - Coordinator
public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    let logger: Logger = Logger(from: type(of: Coordinator.self))
    var parent: JLKernel.WebView
    weak var webView: WKWebView?

    init(_ parent: JLKernel.WebView) {
        self.parent = parent
    }

    // MARK: Webview -> Native
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == JLKernel.WebView.messageHandlerName {
          handleMessage(body: message.body)
      }
    }

    // Extracted for unit testing, since WKScriptMessage cannot be easily mocked
    func handleMessage(body: Any) {
      self.logger.debug("Received message from JS: \(body)")

      // You can pass Strings, Numbers, Arrays, or Dictionaries from JS
      if let bodyDict = body as? [String: Any] {
        self.logger.debug("Received dictionary: \(bodyDict)")

        // Plugin Handlers. The message is a dictionary
        // { name: "<plugin name>", args: {...}, callbackId: "call_N" }
        // sent by the JS bridge (window.jasonelle.post(name, args)).
        // Look up the plugin in the plugins dictionary and call
        // its native handler. Example:
        // webview calls from js a native function
        // window.jasonelle.plugins.hello.call()
        // This reaches the native handler:
        // JLPluginHello.Plugin.handle_call(args:callbackId:respond:)
        // The handler then calls respond(script:) which runs
        // respondToJS to send an event back to the JS side, e.g.
        // window.jasonelle.handle({ callbackId: 'call_N', ... })
        // which resolves the promise that window.jasonelle.post returned.
        guard let name = bodyDict["name"] as? String,
              let plugin = parent.plugins[name] else {
          self.logger.warning("No plugin registered for message: \(body)")
          return
        }

        // This is where the native part calls back to the js part
        let args = bodyDict["args"]
        let callbackId = bodyDict["callbackId"] as? String ?? ""
        plugin.handle_call(args: args, callbackId: callbackId) { script in
          self.respondToJS(script: script)
        }
      }
    }

    // MARK: Native -> Webview
    func respondToJS(script: String) {
        self.logger.debug("Evaluating \(script)")
        webView?.evaluateJavaScript(script) { result, error in
            if let error = error {
              self.logger.warning("Error calling JS: \(error)")
            } else {
              self.logger.debug("JS execution result: \(String(describing: result))")
            }
        }
    }

    // MARK: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.logger.info("Finished loading webview")

      // Example of native -> webview call on load finish
      // respondToJS(script: "console.log('Native says hello!');")
    }

    /// Decides whether a navigation should proceed in the webview or open in Safari.
    /// If `allowed` is empty or nil, all URLs load in the webview. Otherwise URLs
    /// whose host is in `allowed` load in the webview, plus the app's own `mainURL`,
    /// and any other URL opens in a modal `SFSafariViewController`.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      let url = navigationAction.request.url
      let policy = decidePolicy(url: url, allowed: parent.config.allowed, mainURL: parent.config.url)

      self.logger.debug("Loading URL \(String(describing: url)): \(policy)")
      
      if policy == .cancel {
        self.logger.debug("URL \(String(describing: url)) not allowed, opening in Safari")
        if let url {
          presentSafari(url: url, from: webView)
        }
      }

      decisionHandler(policy)
    }

    /// Cancels main-frame responses the webview cannot render (downloads) and
    /// hands them to Safari, which downloads them natively.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
      if navigationResponse.isForMainFrame,
         !navigationResponse.canShowMIMEType,
         let url = navigationResponse.response.url {
        self.logger.debug("URL \(url) is a download, opening in Safari")
        presentSafari(url: url, from: webView)
        decisionHandler(.cancel)
        return
      }
      decisionHandler(.allow)
    }

    // Extracted for unit testing, since WKNavigationAction cannot be mocked
    func decidePolicy(url: URL?, allowed: [String]?, mainURL: URL?) -> WKNavigationActionPolicy {
      guard let allowed = allowed, !allowed.isEmpty else {
        // Empty or nil list: allow all URLs in the webview
        return .allow
      }
      guard let host = url?.host, allowed.contains(host) || host == mainURL?.host else {
        return .cancel
      }
      return .allow
    }

    /// Presents a modal `SFSafariViewController` for the given URL.
    private func presentSafari(url: URL, from webView: WKWebView) {
      guard let viewController = findViewController(from: webView) else {
        self.logger.warning("No view controller to present Safari for \(url)")
        return
      }
      
      self.logger.debug("Opening Safari for \(url)")
      let safari = SFSafariViewController(url: url)
      safari.modalPresentationStyle = .pageSheet
      viewController.present(safari, animated: true)
    }

    /// Walks the responder chain from the webview to find the nearest `UIViewController`.
    private func findViewController(from webView: WKWebView) -> UIViewController? {
      var responder = webView.next
      while let current = responder {
        if let vc = current as? UIViewController {
          return vc
        }
        responder = current.next
      }
      return nil
    }
}

public struct WebView: UIViewRepresentable {
  public let url: URL
  public let config: AppConfiguration
  public let plugins: [String: JLKernel.Plugin]
  let logger: Logger = Logger(from: type(of: WebView.self))
  
  public init(config: AppConfiguration, plugins: [String: JLKernel.Plugin] = [:]) {
    self.config = config
    self.url = config.url
    self.plugins = plugins
  }

  public static func fromConfiguration(plugins: [String: JLKernel.Plugin] = [:]) -> WebView {
    do {
      let config = try ConfigurationLoader.load()
      return WebView(config: config, plugins: plugins)
    } catch {
      Logger(from: type(of: WebView.self)).error("Failed to load configuration: \(error), falling back to about:blank")
      return WebView(config: AppConfiguration(url: URL(string: "about:blank")!), plugins: plugins)
    }
  }

  // The name of the handler exposed to JavaScript
  public static let messageHandlerName = "jasonelle"

  /// JS injected at document start. `post` returns a Promise that resolves with
  /// the native response, routed back through `handle` by `callbackId`.
  public static let jsBridgeScript = """
    const uuid = () => {
      const bytes = crypto.getRandomValues(new Uint8Array(16));

      bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
      bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant

      return [...bytes]
        .map((b, i) => {
          const hex = b.toString(16).padStart(2, '0');
          return [4, 6, 8, 10].includes(i) ? `-${hex}` : hex;
        })
        .join('');
    };
    
    window.jasonelle = {
        _callbacks: {},
        // Result of calling window.jasonelle.post
        result: {
          resolve: function(args) {
            if (args && args.callbackId && window.jasonelle._callbacks[args.callbackId]) {
                const [resolve, reject] = window.jasonelle._callbacks[args.callbackId];
                delete window.jasonelle._callbacks[args.callbackId];
                delete args.callbackId;
                resolve(args);
            }
          },
          reject: function(args) {
            if (args && args.callbackId && window.jasonelle._callbacks[args.callbackId]) {
                const [resolve, reject] = window.jasonelle._callbacks[args.callbackId];
                delete window.jasonelle._callbacks[args.callbackId];
                delete args.callbackId;
                reject(args);
            }
          },
        },
        post: function(name, args) {
            var callbackId = uuid();
            return new Promise(function(resolve, reject) {
                window.jasonelle._callbacks[callbackId] = [resolve, reject];
                window.webkit.messageHandlers.jasonelle.postMessage({ name: name, args: args, callbackId: callbackId });
            });
        },
        plugins: {},
        handle: function(args) {
          // Implement in plugin for handling native events
          console.log("Jasonelle", "Handled event", args);
        },
    };
    """

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public func makeUIView(context: Context) -> WKWebView {
    let preferences = WKWebpagePreferences()
    preferences.allowsContentJavaScript = true

    let configuration = WKWebViewConfiguration()
    configuration.defaultWebpagePreferences = preferences

    // 1. Setup JS Bridge: Webview -> Native
    configuration.userContentController.add(context.coordinator, name: WebView.messageHandlerName)

    // Inject a JS helper to make calling the native bridge easier from web code.
    let userScript = WKUserScript(source: WebView.jsBridgeScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)

    configuration.userContentController.addUserScript(userScript)

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator

    if #available(iOS 16.4, *) {
        if self.config.inspectable ?? false {
          self.logger.debug("WebView inspection: enabled")
          webView.isInspectable = true
        } else {
          self.logger.debug("WebView inspection: disabled")
        }
    } else {
      self.logger.debug("WebView inspection: enabled (iOS <= 16.4)")
    }

    // Inject before first load so user scripts apply to the initial page
    injectUserScripts(into: webView)

    // Store reference to webView in coordinator so we can call native -> JS later
    context.coordinator.webView = webView

    return webView
  }

  /// Injects plugin scripts (Plugin.js) followed by the app's `webview.js`
  /// so they apply to the initial page load. Extracted for unit testing,
  /// since a SwiftUI `Context` cannot be fabricated in tests. The `bundle`
  /// defaults to `Bundle.main` (the app bundle) and is overridable so tests
  /// can point at their own fixture resources.
  public func injectUserScripts(into webView: WKWebView, bundle: Bundle = .main) {
    JLKernel.Plugin.inject(with: plugins, into: webView)

    // Inject app scripts (webview.js) after plugin scripts
    self.logger.debug("Injecting app scripts")
    if let appScriptsURL = bundle.url(forResource: "webview", withExtension: "js"),
       let appScripts = try? String(contentsOf: appScriptsURL, encoding: .utf8) {
      let script = WKUserScript(source: appScripts, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
      webView.configuration.userContentController.addUserScript(script)
    }
  }

  public func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
