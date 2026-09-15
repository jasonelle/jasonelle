//
//  JLPluginDeviceTests/JLPluginDeviceTests.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-05
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
@testable import JLPluginDevice

struct JLPluginDeviceTests {

    @Test func exposesNameAndId() async throws {
      #expect(JLPluginDevice.Plugin.name == "device")
      #expect(JLPluginDevice.Plugin.id == "com.jasonelle.plugins.device")
    }

    @Test func callRespondsWithDeviceInfoScript() async throws {
      let plugin = JLPluginDevice.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: nil) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
      #expect(response?.contains("\"status\":\"ok\"") == true)
      #expect(response?.contains("\"callbackId\":\"call_1\"") == true)
      #expect(response?.contains("\"vendor\":\"apple\"") == true)
      #expect(response?.contains("\"os\":{") == true)
      #expect(response?.contains("\"name\":\"ios\"") == true)
      #expect(response?.contains("\"type\":\"") == true)
      #expect(response?.contains("\"orientation\":\"") == true)
      #expect(response?.contains("\"screen\":{") == true)
      #expect(response?.contains("\"width\":") == true)
      #expect(response?.contains("\"height\":") == true)
    }

    @Test func eventWithoutHandlerDoesNotRespond() async throws {
      let plugin = JLPluginDevice.Plugin()
      var response: String?

      plugin.handle_event("onAppear", args: nil) { response = $0 }

      #expect(response == nil)
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginDevice.Plugin().js()

      #expect(!js.isEmpty)
      #expect(js.contains("window.jasonelle.plugins.device"))
    }
}
