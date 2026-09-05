//
//  JLPluginHello.swift
//  JLPluginHello
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import JLKernel

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "com.jasonelle.plugins.hello" }

  // Native handler called when JS invokes window.jasonelle.plugins.hello.call()
  public override func handle_call(args: Any?, respond: @escaping (String) -> Void) {
    self.logger.info("Handled in native code with args: \(String(describing: args))")
    
    respond("window.jasonelle.plugins.hello.handle({ status: 'ok' });")
  }

  // Native handler called when a native event is triggered (e.g. viewDidLoad)
  public override func handle_event(name: String, args: Any? = [], respond: @escaping (String) -> Void) {
    self.logger.info("Handled event \(name) in native code with args: \(String(describing: args))")

    respond("window.jasonelle.plugins.hello.handle({ status: 'ok', name: '\(name)' });")
  }
}
