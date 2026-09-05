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

    @Test func exposesReverseDomainName() async throws {
      #expect(JLPluginHello.Plugin.name == "com.jasonelle.plugins.hello")
    }

    @Test func callRespondsWithHandleScript() async throws {
      let plugin = JLPluginHello.Plugin()
        var response: String?

        plugin.handle_call(args: ["message": "Hello"], respond: { response = $0 })

        #expect(response == "window.jasonelle.plugins.hello.handle({ status: 'ok' });")
    }

    @Test func eventRespondsWithHandleScript() async throws {
      let plugin = JLPluginHello.Plugin()
        var response: String?

        plugin.handle_event(name: "viewDidLoad", args: nil) { response = $0 }

        #expect(response == "window.jasonelle.plugins.hello.handle({ status: 'ok', name: 'viewDidLoad' });")
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginHello.Plugin().js()

        #expect(!js.isEmpty)
        #expect(js.contains("window.jasonelle.plugins.hello"))
    }
}
