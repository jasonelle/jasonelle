//
//  JLKernelTests.swift
//  JLKernelTests
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import Testing
@testable import JLKernel

struct JLKernelTests {

    final class StubPlugin: JLPlugin {
        var receivedArgs: [String: Any]?

        override public func call(args: [String : Any], respond: @escaping (String) -> Void) {
            self.receivedArgs = args
        }
    }

    @Test @MainActor func dispatchesToRegisteredPlugin() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(url: URL(string: "https://jasonelle.com")!, plugins: ["stub": plugin])
        let coordinator = webview.makeCoordinator()

        coordinator.handleMessage(body: ["name": "stub", "args": ["value": 42]])

        #expect(plugin.receivedArgs?["value"] as? Int == 42)
    }

    @Test @MainActor func ignoresUnknownPlugins() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(url: URL(string: "https://jasonelle.com")!, plugins: ["stub": plugin])
        let coordinator = webview.makeCoordinator()

        coordinator.handleMessage(body: ["name": "missing", "args": [:]])
        coordinator.handleMessage(body: "not a dictionary")

        #expect(plugin.receivedArgs == nil)
    }

}
