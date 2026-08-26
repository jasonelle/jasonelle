//
//  JLPlugin.swift
//  JLKernel
//
//  Created by Camilo on 22-08-26.
//
import Foundation
import WebKit

open class Plugin {
  /// Set (override) this class property in each subclass.
  /// The name must follow reverse domain notation com.jasonelle.plugins.*
  open class var name: String {
    String(describing: self)
  }
  
  public let logger : Logger;
  
  public init() {
    self.logger = Logger(from: Self.name)
  }
  
  // Native handler invoked when JS calls this plugin through the bridge.
  // Call respond(script) to send an event back to the JS side.
  open func call(args: Any?, respond: @escaping (String) -> Void) {
    self.logger.warning("Plugin \(Self.name) has no native handler implemented")
    respond("")
  }
  
  public func js() -> String {
    guard let url = Bundle(for: type(of: self)).url(forResource: "plugin", withExtension: "js"),
        let data = try? Data(contentsOf: url),
        let content = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    else { return "" }
    return content
  }
  
  public func inject(into webview: WKWebView) {
    self.logger.info("Injecting plugin \(Self.name) into webview")
    
    let script = WKUserScript(source: js(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
    self.logger.debug(script.source)
    
    webview.configuration.userContentController.addUserScript(script)
  }
  
  public static func inject(with plugins: [String : JLKernel.Plugin], into webview: WKWebView) {
    for (_, plugin) in plugins {
      plugin.inject(into: webview)
    }
  }
}
