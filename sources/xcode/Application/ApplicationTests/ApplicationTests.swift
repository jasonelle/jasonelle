//
//  ApplicationTests.swift
//  ApplicationTests
//
//  Created by Camilo on 19-08-26.
//

import Testing
@testable import Application
import JLKernel
import JLPluginHello

struct ApplicationTests {

    @Test func pluginsNotEmpty() {
        #expect(!plugins.isEmpty)
    }

    @Test func helloPluginRegisteredWithCorrectKey() {
        let key = JLPluginHello.Plugin.id
        #expect(plugins[key] != nil)
    }

    @Test func helloPluginNameMatchesKey() {
        let key = JLPluginHello.Plugin.id
        let plugin = plugins[key]
        #expect(type(of: plugin!) == JLPluginHello.Plugin.self)
    }

    @Test func helloPluginRespondsToCall() async {
        let plugin = plugins[JLPluginHello.Plugin.id]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_call(callbackId: "call_1", args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(!response.isEmpty)
    }

    @Test func helloPluginRespondsToEvent() async {
        let plugin = plugins[JLPluginHello.Plugin.id]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_event("viewDidLoad", args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(response.contains("window.jasonelle.plugins.hello.handle"))
    }

}
