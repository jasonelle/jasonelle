//
//  JLPluginHelloTests.swift
//  JLPluginHelloTests
//
//  Created by Camilo on 19-08-26.
//

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
