//
//  JLPluginAppleSignInTests/JLPluginAppleSignInTests.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-15
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
import Testing
@testable import JLPluginAppleSignIn

struct JLPluginAppleSignInTests {

  @Test func exposesNameAndId() async throws {
    #expect(JLPluginAppleSignIn.Plugin.name == "applesignin")
    #expect(JLPluginAppleSignIn.Plugin.id == "com.jasonelle.plugins.applesignin")
  }

  @Test func bundlesJavaScriptRegisteringPluginAndHelpers() async throws {
    let js = JLPluginAppleSignIn.Plugin().js()

    #expect(!js.isEmpty)
    #expect(js.contains("window.jasonelle.plugins.applesignin"))
    #expect(js.contains("window.jasonelle.plugins.appleSignIn"))
    #expect(js.contains("createButton"))
    #expect(js.contains("renderButton"))
    #expect(js.contains("signIn"))
    #expect(js.contains("getCredentialState"))
  }

  @Test func unknownActionRespondsWithRejectScript() async throws {
    let plugin = JLPluginAppleSignIn.Plugin()
    var response: String?

    plugin.handle_call(callbackId: "call_unknown", args: ["action": "invalidAction"]) {
      response = $0
    }

    #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
    #expect(response?.contains("\"status\":\"error\"") == true)
    #expect(response?.contains("\"callbackId\":\"call_unknown\"") == true)
    #expect(response?.contains("Unknown action") == true)
  }

  @Test func getCredentialStateWithoutUserIDRejects() async throws {
    let plugin = JLPluginAppleSignIn.Plugin()
    var response: String?

    plugin.handle_call(callbackId: "call_state", args: ["action": "getCredentialState"]) {
      response = $0
    }

    #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
    #expect(response?.contains("\"status\":\"error\"") == true)
    #expect(response?.contains("Missing 'userID' parameter") == true)
  }

  @Test func getCredentialStateWithEmptyUserIDRejects() async throws {
    let plugin = JLPluginAppleSignIn.Plugin()
    var response: String?

    plugin.handle_call(callbackId: "call_empty_user", args: ["action": "getCredentialState", "userID": ""]) {
      response = $0
    }

    #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
    #expect(response?.contains("\"status\":\"error\"") == true)
    #expect(response?.contains("Missing 'userID' parameter") == true)
  }

  #if os(iOS)
  @Test @MainActor func hideNativeButtonRespondsWithOk() async throws {
    let plugin = JLPluginAppleSignIn.Plugin()
    var response: String?

    plugin.handle_call(callbackId: "call_hide", args: ["action": "hideNativeButton"]) {
      response = $0
    }

    #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
    #expect(response?.contains("\"status\":\"ok\"") == true)
    #expect(response?.contains("\"callbackId\":\"call_hide\"") == true)
  }
  #endif
}
