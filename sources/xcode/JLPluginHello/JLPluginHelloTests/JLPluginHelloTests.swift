//
//  JLPluginHelloTests/JLPluginHelloTests.swift
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
import Testing
import JLKernel
@testable import JLPluginHello

struct JLPluginHelloTests {

    @Test func exposesNameAndId() async throws {
      #expect(JLPluginHello.Plugin.name == "hello")
      #expect(JLPluginHello.Plugin.id == "com.jasonelle.plugins.hello")
    }

    @Test func defaultCallResolvesWithArgs() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: ["message": "Hello"]) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
      #expect(response?.contains("\"status\":\"ok\"") == true)
      #expect(response?.contains("\"callbackId\":\"call_1\"") == true)
      #expect(response?.contains("\"message\":\"Hello\"") == true)
    }

    @Test func helloActionResolves() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "c_hello", args: ["action": "hello"]) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
      #expect(response?.contains("\"status\":\"ok\"") == true)
      #expect(response?.contains("\"callbackId\":\"c_hello\"") == true)
    }

    @Test func worldActionResolvesWithValue() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "c_world", args: ["action": "world", "args": "Jasonelle"]) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
      #expect(response?.contains("\"value\":\"Jasonelle\"") == true)
      #expect(response?.contains("\"callbackId\":\"c_world\"") == true)
    }

    @Test func worldActionRejectsWhenArgsMissing() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "c_world_err", args: ["action": "world"]) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
      #expect(response?.contains("\"status\":\"error\"") == true)
    }

    @Test func eventRespondsWithHandleScript() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_event("viewDidLoad", args: nil) { response = $0 }

      #expect(response?.contains("window.jasonelle.plugins.hello.handle(") == true)
      #expect(response?.contains("\"event\":\"viewDidLoad\"") == true)
      #expect(response?.contains("\"plugin\":\"hello\"") == true)
      #expect(response?.contains("\"status\":\"ok\"") == true)
    }

    @Test func eventPassesArgsThrough() async throws {
      let plugin = JLPluginHello.Plugin()
      var response: String?

      plugin.handle_event("onAppear", args: ["key": "val"]) { response = $0 }

      #expect(response?.contains("window.jasonelle.plugins.hello.handle(") == true)
      #expect(response?.contains("\"key\":\"val\"") == true)
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginHello.Plugin().js()

      #expect(!js.isEmpty)
      #expect(js.contains("window.jasonelle.plugins.hello"))
      #expect(js.contains("plugin.hello"))
      #expect(js.contains("plugin.world"))
    }
}
