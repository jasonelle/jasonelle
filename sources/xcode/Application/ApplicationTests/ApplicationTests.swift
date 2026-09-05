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
        let key = JLPluginHello.Plugin.name
        #expect(plugins[key] != nil)
    }

    @Test func helloPluginNameMatchesKey() {
        let key = JLPluginHello.Plugin.name
        let plugin = plugins[key]
        #expect(type(of: plugin!) == JLPluginHello.Plugin.self)
    }

    @Test func helloPluginRespondsToCall() async {
        let plugin = plugins[JLPluginHello.Plugin.name]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_call(args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(!response.isEmpty)
    }

    @Test func helloPluginRespondsToEvent() async {
        let plugin = plugins[JLPluginHello.Plugin.name]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_event(name: "viewDidLoad", args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(response.contains("window.jasonelle.plugins.hello.handle"))
    }

}
