//
//  JLKernelTests.swift
//  JLKernelTests
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import Testing
import WebKit
@testable import JLKernel

@Suite(.serialized) struct JLKernelTests {

    final class StubPlugin: JLKernel.Plugin {
        var receivedArgs: Any?

        override public func handle_call(args: Any?, respond: @escaping (String) -> Void) {
            self.receivedArgs = args
        }
    }

    @Test @MainActor func dispatchesToRegisteredPlugin() async throws {
        let plugin = StubPlugin()
        let webview = JLKernel.WebView(config: AppConfiguration(url: URL(string: "https://jasonelle.com")!), plugins: ["stub": plugin])
        let coordinator = webview.makeCoordinator()

        coordinator.handleMessage(body: ["name": "stub", "args": ["value": 42]])

        #expect((plugin.receivedArgs as? [String: Any])?["value"] as? Int == 42)
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

// MARK: - Plugin

final class UnconfiguredPlugin: JLKernel.Plugin {}

struct PluginTests {

    @Test func defaultNameIsTypeName() {
        #expect(UnconfiguredPlugin.name == "UnconfiguredPlugin")
    }

    @Test func defaultCallRespondsWithWarningScript() {
        var response: String?

        UnconfiguredPlugin().handle_call(args: nil) { response = $0 }

        #expect(response == "console.log('jasonelle: no handler for UnconfiguredPlugin');")
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
