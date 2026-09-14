//
//  JLPluginHello.swift
//  JLPluginHello
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import JLKernel

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "hello" }

  // Native handler called when JS invokes window.jasonelle.plugins.hello.call()
  public override func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.info("Handled in native code with args: \(String(describing: args))")

    switch args?["action"] as? String {
    case "hello":
      self.logger.info("Resolved with hello response")
      self.hello()
      self.resolve(args: ["status": "ok"], callbackId: callbackId, respond: respond)

    case "world":
      self.logger.info("Resolved with world response")
      guard let value = args?["args"] as? String else {
        self.reject(args: ["error": "Missing 'value'"], callbackId: callbackId, status: "error", respond: respond)
        return
      }
      
      self.resolve(args: ["value": self.world(value: value)], callbackId: callbackId, respond: respond)

    default:
      self.logger.info("Resolved with default response")
      self.resolve(args: args ?? [:], callbackId: callbackId, respond: respond)
    }
    
  }
  
  private func hello() {
    self.logger.notice("Hello, world!")
  }
  
  private func world(value: String) -> String {
    self.logger.notice("Hello, world! => \(value)")
    return value
  }

  // Native handler called when a native event is triggered (e.g. onAppear)
  public override func handle_event(_ event: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.debug("Handled event \(event) in native code with args: \(String(describing: args))")

    self.event(event, plugin: Plugin.name, args: args ?? [:], respond: respond)
  }
}
