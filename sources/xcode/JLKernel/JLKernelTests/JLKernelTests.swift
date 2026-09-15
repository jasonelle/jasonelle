//
//  JLKernelTests/JLKernelTests.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-06
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
import Testing
import WebKit
@testable import JLKernel

@Suite(.serialized) struct JLKernelTests {

    final class StubPlugin: JLKernel.Plugin {
        var receivedArgs: Any?
        var receivedCallbackId: String?

        override public func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
            self.receivedArgs = args
            self.receivedCallbackId = callbackId
        }
    }

    @Test @MainActor func dispatchesToRegisteredPlugin() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(config: AppConfiguration(url: URL(string: "https://jasonelle.com")!), plugins: ["stub": plugin])
        let coordinator = webview.makeCoordinator()

        coordinator.handleMessage(body: ["name": "stub", "args": ["value": 42], "callbackId": "call_1"])

        #expect((plugin.receivedArgs as? [String: Any])?["value"] as? Int == 42)
        #expect(plugin.receivedCallbackId == "call_1")
    }

    @Test @MainActor func ignoresUnknownPlugins() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(config: AppConfiguration(url: URL(string: "https://jasonelle.com")!), plugins: ["stub": plugin])
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
        #expect(LogLevel.debug < LogLevel.info)
        #expect(LogLevel.info < LogLevel.notice)
        #expect(LogLevel.emergency > LogLevel.alert)
    }

}

// MARK: - License

struct LicenseTests {

    private func makeLicense(
        key: String? = "",
        isSimulator: Bool
    ) -> License {
        License(key: key) { isSimulator }
    }

    @Test func checkWithValidKeyDoesNotCrash() {
        makeLicense(key: "test-key", isSimulator: false).check()
    }

    @Test func checkWithEmptyKeyOnSimulatorDoesNotCrash() {
        makeLicense(isSimulator: true).check()
    }

    @Test func abortReturnsOnSimulator() {
        makeLicense(isSimulator: true).abortIfIsInSimulator()
    }

    @Test func checkWithNilKeyOnSimulatorDoesNotCrash() {
        makeLicense(key: nil, isSimulator: true).check()
    }

    @Test func checkWithPurchaseMeKeyOnSimulatorDoesNotCrash() {
        makeLicense(key: "PURCHASE_ME", isSimulator: true).check()
    }

    @Test func checkWithValidKeyOnSimulatorDoesNotCrash() {
        makeLicense(key: "real-key", isSimulator: true).check()
    }

    @Test func verifyWithKeyDoesNotCrash() {
        License.verify(key: "test-key")
    }

    @Test func verifyWithEmptyKeyOnSimulatorDoesNotCrash() {
        License.verify(key: "")
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

// MARK: - Event

final class EventStubPlugin: JLKernel.Plugin {
    var receivedNames: [String] = []

    override func handle_event(_ event: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
        receivedNames.append(event)
        respond("")
    }
}

struct EventTests {

    @Test func onAppearSendDispatchesToRegisteredPlugins() {
        let plugins: [String: JLKernel.Plugin] = [
            "a": EventStubPlugin(),
            "b": EventStubPlugin()
        ]
        Events.plugins = plugins
        defer { Events.plugins = [:] }

        JLKernel.Events.sendOnAppear()

        let names = plugins.values.compactMap { ($0 as? EventStubPlugin)?.receivedNames }.flatMap { $0 }
        #expect(names.count == 2)
        #expect(names.allSatisfy { $0 == Events.contentViewOnAppear.rawValue })
    }

    @Test func onAppearSendWithNoPluginsIsNoop() {
        Events.plugins = [:]
        defer { Events.plugins = [:] }

        JLKernel.Events.sendOnAppear()
    }

}

// MARK: - Plugin

final class UnconfiguredPlugin: JLKernel.Plugin {}

struct PluginTests {

    @Test func defaultNameIsTypeName() {
        #expect(UnconfiguredPlugin.name == "UnconfiguredPlugin")
    }

    @Test func defaultCallDoesNotRespond() {
        var response: String?

        UnconfiguredPlugin().handle_call(callbackId: "call_1", args: nil) { response = $0 }

        #expect(response == nil)
    }

    @Test func defaultEventDoesNotRespond() {
        var response: String?

        UnconfiguredPlugin().handle_event("viewDidLoad", args: nil) { response = $0 }

        #expect(response == nil)
    }

    @Test func jsLoadsBundledPluginJS() {
        let source = UnconfiguredPlugin().js()

        #expect(source.contains("window.jasonelle.plugins.stub"))
    }

}

// MARK: - Navigation policy (allowed hosts)

struct NavigationPolicyTests {

    private let mainURL = URL(string: "https://jasonelle.com")!

    @MainActor private func makeCoordinator() -> Coordinator {
        JLKernel.WebView(config: AppConfiguration(url: mainURL)).makeCoordinator()
    }

    @Test @MainActor func allowsEveryURLWhenAllowedIsEmptyOrNil() async throws {
        let coordinator = makeCoordinator()

        #expect(coordinator.decidePolicy(url: URL(string: "https://anything.com"), allowed: [], mainURL: mainURL) == .allow)
        #expect(coordinator.decidePolicy(url: URL(string: "https://anything.com"), allowed: nil, mainURL: mainURL) == .allow)
        #expect(coordinator.decidePolicy(url: nil, allowed: nil, mainURL: mainURL) == .allow)
    }

    @Test @MainActor func allowsURLsWhoseHostIsInAllowedList() async throws {
        let coordinator = makeCoordinator()

        #expect(coordinator.decidePolicy(url: URL(string: "https://jasonelle.com/foo?bar=1"), allowed: ["jasonelle.com"], mainURL: mainURL) == .allow)
    }

    @Test @MainActor func cancelsURLsWhoseHostIsNotInAllowedList() async throws {
        let coordinator = makeCoordinator()

        #expect(coordinator.decidePolicy(url: URL(string: "https://evil.com"), allowed: ["jasonelle.com"], mainURL: mainURL) == .cancel)
        #expect(coordinator.decidePolicy(url: URL(string: "file:///tmp/x"), allowed: ["jasonelle.com"], mainURL: mainURL) == .cancel)
    }

    @Test @MainActor func alwaysAllowsTheAppURL() async throws {
        let coordinator = makeCoordinator()

        #expect(coordinator.decidePolicy(url: mainURL, allowed: ["other.com"], mainURL: mainURL) == .allow)
    }

}

// MARK: - WebView user script injection (plugins + webview.js)

struct WebViewScriptInjectionTests {

    @Test func bridgePostsReturnPromiseRoutedByCallbackId() {
        let source = JLKernel.WebView.jsBridgeScript

        #expect(source.contains("new Promise"))
        #expect(source.contains("callbackId"))
        #expect(source.contains("postMessage"))
    }

    @Test @MainActor func injectsWebViewJSAfterPluginScripts() async throws {
        let webview = JLKernel.WebView(
            config: AppConfiguration(url: URL(string: "https://jasonelle.com")!),
            plugins: ["stub": JLKernelTests.StubPlugin()]
        )
        let target = WKWebView()

        // The bundle that contains the test fixtures (this mock webview.js)
        let bundle = Bundle(for: JLKernelTests.StubPlugin.self)

        webview.injectUserScripts(into: target, bundle: bundle)

        let sources = target.configuration.userContentController.userScripts.map(\.source)

        // The plugin script from the test bundle is injected first
        #expect(sources.contains { $0.contains("window.jasonelle.plugins.stub") })
        // The mocked webview.js is injected last, after the plugin scripts
        #expect(sources.last?.contains("JLKernelTests webview.js") == true)
        #expect(sources.dropLast().contains { $0.contains("window.jasonelle.plugins.stub") })
    }

}

// MARK: - ConfigurationLoader

struct ConfigurationLoaderTests {

    @Test func decodeReturnsURLFromValidJSON() throws {
        let json = #"{"url": "https://example.com"}"#
        let data = Data(json.utf8)

        let config = try ConfigurationLoader.decode(data: data)

        #expect(config.url == URL(string: "https://example.com"))
    }

    @Test func decodeStripsJSONCComments() throws {
        let json = #"{/* comment */"url": "https://example.com"}"#
        let data = Data(json.utf8)

        let config = try ConfigurationLoader.decode(data: data)

        #expect(config.url == URL(string: "https://example.com"))
    }

    @Test func decodeThrowsOnInvalidJSON() {
        let data = Data("not json".utf8)

        #expect(throws: ConfigurationError.self) {
            try ConfigurationLoader.decode(data: data)
        }
    }

    @Test func loadThrowsFileNotFoundWhenURLIsNil() {
        #expect(throws: ConfigurationError.self) {
            try ConfigurationLoader.load(from: nil)
        }
    }

    @Test func loadReadsConfigFile() throws {
        let configURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("config.jsonc")

        let config = try ConfigurationLoader.load(from: configURL)

        #expect(config.url == URL(string: "https://jasonelle.com"))
    }

}
