//
//  JLPluginDeviceTests.swift
//  JLPluginDeviceTests
//
//  Created by Camilo on 05-09-26.
//

import Foundation
import Testing
import JLKernel
@testable import JLPluginDevice

struct JLPluginDeviceTests {

    @Test func exposesReverseDomainName() async throws {
      #expect(JLPluginDevice.Plugin.name == "com.jasonelle.plugins.device")
    }

    @Test func callRespondsWithDeviceInfoScript() async throws {
      let plugin = JLPluginDevice.Plugin()
        var response: String?

        plugin.handle_call(args: nil, respond: { response = $0 })

        #expect(response?.hasPrefix("window.jasonelle.plugins.device.handle({") == true)
        #expect(response?.contains("vendor: 'apple'") == true)
        #expect(response?.contains("os: {") == true)
        #expect(response?.contains("name: 'ios'") == true)
        #expect(response?.contains("type: '") == true)
        #expect(response?.contains("orientation: '") == true)
        #expect(response?.contains("screen: {") == true)
        #expect(response?.contains("width:") == true)
        #expect(response?.contains("height:") == true)
    }

    @Test func eventRespondsWithHandleScript() async throws {
      let plugin = JLPluginDevice.Plugin()
        var response: String?

        plugin.handle_event(name: "viewDidLoad", args: nil) { response = $0 }

        #expect(response == "window.jasonelle.plugins.device.handle({ status: 'ok', name: 'viewDidLoad' });")
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginDevice.Plugin().js()

        #expect(!js.isEmpty)
        #expect(js.contains("window.jasonelle.plugins.device"))
    }
}