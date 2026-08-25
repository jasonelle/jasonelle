//
//  JLKernelTests.swift
//  JLKernelTests
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import Testing
@testable import JLKernel

@Suite(.serialized) struct JLKernelTests {

    final class StubPlugin: JLPlugin {
        var receivedArgs: Any?

        override public func call(args: Any?, respond: @escaping (String) -> Void) {
            self.receivedArgs = args
        }
    }

    @Test @MainActor func dispatchesToRegisteredPlugin() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(url: URL(string: "https://jasonelle.com")!, plugins: ["stub": plugin])
        let coordinator = webview.makeCoordinator()

        coordinator.handleMessage(body: ["name": "stub", "args": ["value": 42]])

        #expect((plugin.receivedArgs as? [String: Any])?["value"] as? Int == 42)
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

// MARK: - Ratlog

struct RatlogTests {

    @Test func formatsTagsMessageAndSortedFields() {
        let output = Ratlog.format(message: "hello", tags: ["b", "a"], fields: ["z": "1", "a": "2"])

        #expect(output == "[b|a] hello | a: 2 | z: 1")
    }

    @Test func omitsEmptyTagsAndFields() {
        #expect(Ratlog.format(message: "hi", tags: [], fields: [:]) == "hi")
    }

    @Test func omitsTagsOnly() {
        #expect(Ratlog.format(message: "hi", tags: [], fields: ["a": "1"]) == "hi | a: 1")
        #expect(Ratlog.format(message: "hi", tags: ["t"], fields: [:]) == "[t] hi")
    }

}

// MARK: - LogLevel

struct LogLevelTests {

    @Test func comparesBySeverity() {
        #expect(JLLogLevel.debug < JLLogLevel.info)
        #expect(JLLogLevel.info < JLLogLevel.notice)
        #expect(JLLogLevel.emergency > JLLogLevel.alert)
    }

}

// MARK: - Version

struct VersionTests {

    @Test func semanticReturnsTrimmedBundledVersion() {
        let version = Version.semantic()

        #expect(!version.isEmpty)
        #expect(version == version.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func semanticHonorsOverride() {
        Version.version = "9.9.9-test"
        defer { Version.version = nil }

        #expect(Version.semantic() == "9.9.9-test")
    }

}

// MARK: - Plugin

final class UnconfiguredPlugin: JLPlugin {}

struct PluginTests {

    @Test func defaultNameIsTypeName() {
        #expect(UnconfiguredPlugin.name == "UnconfiguredPlugin")
    }

    @Test func defaultCallRespondsEmptyString() {
        var response: String?

        UnconfiguredPlugin().call(args: nil) { response = $0 }

        #expect(response == "")
    }

    @Test func jsLoadsBundledPluginJS() {
        let source = UnconfiguredPlugin().js()

        #expect(source.contains("window.jasonelle.plugins.stub"))
    }

}
