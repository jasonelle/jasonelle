//
//  JLPlugin.swift
//  JLKernel
//
//  Created by Camilo on 22-08-26.
//
import Foundation
import WebKit

open class JLPlugin {
  public init() {}
  
  public func js() -> String {
    guard let url = Bundle(for: type(of: self)).url(forResource: "plugin", withExtension: "js"),
        let data = try? Data(contentsOf: url),
        let content = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    else { return "" }
    return content
  }
  
  public func inject(into webview: WKWebView) -> WKWebView {
    let script = WKUserScript(source: js(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    webview.configuration.userContentController.addUserScript(script)
    return webview
  }
}
