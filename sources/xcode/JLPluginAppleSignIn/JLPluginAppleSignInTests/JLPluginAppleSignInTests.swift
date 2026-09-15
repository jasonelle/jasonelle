//
//  JLPluginAppleSignInTests.swift
//  JLPluginAppleSignInTests
//
//  Created by Camilo on 15-09-26.
//

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
