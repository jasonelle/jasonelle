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
        // { name: "<plugin name>", args: {...} } sent by the
        // JS bridge (window.jasonelle.post(name, args)).
        // Look up the plugin in the plugins dictionary and call
        // its native handler. Example:
        // webview calls from js a native function
        // window.jasonelle.plugins.hello.call()
        // This reaches the native handler:
        // JLPluginHello.Plugin.handle_call(args:respond:)
        // The handler then calls respond(script:) which runs
        // respondToJS to send an event back to the JS side, e.g.
        // window.jasonelle.plugins.hello.handle(args)
        guard let name = bodyDict["name"] as? String,
              let plugin = parent.plugins[name] else {
          self.logger.warning("No plugin registered for message: \(body)")
          return
        }

        // This is where the native part calls back to the js part
        let args = bodyDict["args"]
        plugin.handle_call(args: args) { script in
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
    /// whose host is in `allowed` load in the webview and any other URL opens in
    /// a modal `SFSafariViewController`.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      guard let allowed = parent.config.allowed, !allowed.isEmpty,
            let url = navigationAction.request.url else {
        // Empty or nil list: allow all URLs in the webview
        self.logger.info("Allow all URLs in the webview")
        self.logger.debug("All URLs allowed, loading in webview")
        self.logger.debug("Allowed hosts: \(parent.config.allowed ?? [])")
        decisionHandler(.allow)
        return
      }

      if let host = url.host, allowed.contains(host) {
        decisionHandler(.allow)
      } else {
        self.logger.debug("URL \(url) not allowed, opening in Safari")
        presentSafari(url: url, from: webView)
        decisionHandler(.cancel)
      }
    }

    /// Presents a modal `SFSafariViewController` for the given URL.
    private func presentSafari(url: URL, from webView: WKWebView) {
      guard let viewController = findViewController(from: webView) else {
        self.logger.warning("No view controller to present Safari for \(url)")
        return
      }
      self.logger.debug("Opening Safari for \(url)")
      let safari = SFSafariViewController(url: url)
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

    // Inject a JS helper to make calling the native bridge easier from web code
    let jsBridgeScript = """
    window.jasonelle = {
        post: function(name, args) {
            return window.webkit.messageHandlers.\(WebView.messageHandlerName).postMessage({ name: name, args: args });
        },
        plugins: {},
        handle: function(args) {console.log("Jasonelle", "Handled event", args);}
    };
    """

    let userScript = WKUserScript(source: jsBridgeScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)

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
    }

    // Inject before first load so user scripts apply to the initial page
    JLKernel.Plugin.inject(with: plugins, into: webView)

    // Store reference to webView in coordinator so we can call native -> JS later
    context.coordinator.webView = webView

    return webView
  }

  public func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
