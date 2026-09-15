//
//  JLKernel/Plugin.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-26
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.

import Foundation
import WebKit

open class Plugin {
  /// The name is the key inside the plugin object in JS
  open class var name: String {
    String(describing: self)
  }
  
  /// The id must follow reverse domain notation example: com.jasonelle.plugins.{{name}}
  open class var id: String {
    "com.jasonelle.plugins.\(Self.name)"
  }

  public let logger: Logger

  public init() {
    self.logger = Logger(from: "Plugin.\(Self.name)")
  }

  // Native handler invoked when JS calls this plugin through the bridge.
  // Call respond(script) to send the response back to the JS promise
  // associated with callbackId.
  open func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.notice("Plugin \(Self.name) has no native call handler implemented")
  }
  
  // Native handler invoked when a native event is triggered (e.g. viewDidLoad).
  // Call respond(script) to send an event back to the JS side.
  open func handle_event(_ event: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.notice("Plugin \(Self.name) has no native event handler implemented for \(event)")
  }
  
  public func resolve(args: [String: Any], callbackId: String,  status : String = "ok", respond: @escaping (String) -> Void) {
    do {
        let response = ["status": status, "callbackId": callbackId].merging(args) { (_, new) in new }
      
        self.logger.debug("resolve: Sending response: \(response)")
      
        let data = try JSONSerialization.data(withJSONObject: response)
        let json = String(data: data, encoding: .utf8)!

        let js = """
        window.jasonelle.result.resolve(\(json));
        """
        
        respond(js)
    } catch {
      self.logger.notice("Failed to convert dictionary to JSON: \(error)")
    }
  }
  
  public func reject(args: [String: Any], callbackId: String, status : String = "ok", respond: @escaping (String) -> Void) {
    do {
        let response = ["status": status, "callbackId": callbackId].merging(args) { (_, new) in new }
      
        self.logger.debug("reject: Sending response: \(response)")
      
        let data = try JSONSerialization.data(withJSONObject: response)
        let json = String(data: data, encoding: .utf8)!

        let js = """
        window.jasonelle.result.reject(\(json));
        """
      
        respond(js)
    } catch {
      self.logger.notice("Failed to convert dictionary to JSON: \(error)")
    }
  }
  
  public func event(_ event: String, plugin: String, args: [String: Any], status : String = "ok", respond: @escaping (String) -> Void) {
    do {
        let response = ["status": status, "event": event, "plugin": plugin].merging(args) { (_, new) in new }
      
        self.logger.debug("Sending event: \(response)")
      
        let data = try JSONSerialization.data(withJSONObject: response)
        let json = String(data: data, encoding: .utf8)!

        let js = """
             window.jasonelle.plugins.\(plugin).handle(\(json));
        """
      
        respond(js)
    } catch {
      self.logger.notice("Failed to convert dictionary to JSON: \(error)")
    }
  }

  public func js() -> String {
    guard let url = Bundle(for: type(of: self)).url(forResource: "Plugin", withExtension: "js"),
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

  public static func inject(with plugins: [String: JLKernel.Plugin], into webview: WKWebView) {
    Logger(from: Plugin.self).debug("Injecting \(plugins.count) plugins into webview")
    for (_, plugin) in plugins {
      plugin.inject(into: webview)
    }
  }
}
