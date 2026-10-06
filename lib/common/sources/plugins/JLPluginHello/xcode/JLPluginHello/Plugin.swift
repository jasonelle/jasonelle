//
//  JLPluginHello/Plugin.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-19
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
