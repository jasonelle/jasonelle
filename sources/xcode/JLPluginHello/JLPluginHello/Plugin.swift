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

    self.resolve(args: args ?? [:], callbackId: callbackId, respond: respond)
  }

  // Native handler called when a native event is triggered (e.g. onAppear)
  public override func handle_event(_ event: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.debug("Handled event \(event) in native code with args: \(String(describing: args))")

    self.event(event, plugin: Plugin.name, args: args ?? [:], respond: respond)
  }
}
