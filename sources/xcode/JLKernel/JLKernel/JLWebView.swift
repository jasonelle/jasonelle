//
//  JLWebView.swift
//  JLKernel
//
//  Created by Camilo on 23-08-26.
//

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
        // JLPluginHello.Plugin.call(args:respond:)
        // The handler then calls respond(script:) which runs
        // respondToJS to send an event back to the JS side, e.g.
        // window.jasonelle.plugins.hello.handle(args)
        guard let name = bodyDict["name"] as? String,
              let plugin = parent.plugins[name] else {
          self.logger.warning("No plugin registered for message: \(body)")
          return
        }

        let args = bodyDict["args"]
        plugin.call(args: args) { script in
          self.respondToJS(script: script)
        }
      }
    }
    
    // MARK: Native -> Webview
    func respondToJS(script: String) {
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
}

public struct WebView: UIViewRepresentable {
  public let url: URL
  let plugins: [String: JLPlugin]

  public init(url: URL, plugins: [String: JLPlugin] = [:]) {
    self.url = url
    self.plugins = plugins
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
    
    // TODO: Check if this can be configured inside config.jsonc
    if #available(iOS 16.4, *) {
        webView.isInspectable = true
    }

    // Inject before first load so user scripts apply to the initial page
    JLPlugin.inject(with: plugins, into: webView)
    
    // Store reference to webView in coordinator so we can call native -> JS later
    context.coordinator.webView = webView
    
    return webView
  }
  
  public func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
