//
//  JLPluginCookiesTests.swift
//  JLPluginCookiesTests
//
//  Created by Camilo on 07-09-26.
//

import Foundation
import Testing
import JLKernel
@testable import JLPluginCookies

struct JLPluginCookiesTests {

    @Test func exposesNameAndId() async throws {
      #expect(JLPluginCookies.Plugin.name == "cookies")
      #expect(JLPluginCookies.Plugin.id == "com.jasonelle.plugins.cookies")
    }

    @Test func saveRespondsWithOkScript() async throws {
      let plugin = JLPluginCookies.Plugin()
        var response: String?

        plugin.handle_call(callbackId: "call_1", args: ["action": "save", "value": "session=abc"]) { response = $0 }

        #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
        #expect(response?.contains("\"status\":\"ok\"") == true)
        #expect(response?.contains("\"callbackId\":\"call_1\"") == true)
    }

    @Test func restoreRespondsWithValueScript() async throws {
      let plugin = JLPluginCookies.Plugin()
        var response: String?

        plugin.handle_call(callbackId: "call_2", args: ["action": "restore"]) { response = $0 }

        #expect(response?.hasPrefix("window.jasonelle.result.resolve({") == true)
        #expect(response?.contains("\"value\":\"") == true)
    }

    @Test func saveWithoutValueRespondsWithRejectScript() async throws {
      let plugin = JLPluginCookies.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: ["action": "save"]) { response = $0 }

      #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
      #expect(response?.contains("\"status\":\"error\"") == true)
      #expect(response?.contains("\"error\":\"Missing 'value'\"") == true)
    }

    @Test func unknownActionRespondsWithRejectScript() async throws {
      let plugin = JLPluginCookies.Plugin()
        var response: String?

        plugin.handle_call(callbackId: "call_1", args: nil) { response = $0 }

        #expect(response?.hasPrefix("window.jasonelle.result.reject({") == true)
        #expect(response?.contains("\"status\":\"error\"") == true)
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginCookies.Plugin().js()

        #expect(!js.isEmpty)
        #expect(js.contains("window.jasonelle.plugins.cookies"))
    }
}