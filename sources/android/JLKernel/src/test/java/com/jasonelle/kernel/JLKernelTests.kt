//
//  JLKernelTests/JLKernelTests.kt
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-15
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

package com.jasonelle.kernel

import java.io.ByteArrayInputStream
import java.nio.charset.StandardCharsets
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Test

class JLKernelTests {

    class StubPlugin : Plugin() {
        var receivedArgs: Map<String, Any?>? = null
        var receivedCallbackId: String? = null

        override fun handle_call(callbackId: String, args: Map<String, Any?>?, respond: (String) -> Unit) {
            receivedArgs = args
            receivedCallbackId = callbackId
        }
    }

    @Test
    fun dispatchesToRegisteredPlugin() {
        val plugin = StubPlugin()
        val config = AppConfiguration(urlString = "https://jasonelle.com")
        val coordinator = Coordinator(config, mapOf("stub" to plugin))

        coordinator.handleMessage("stub", "call_1", mapOf("value" to 42))

        assertEquals(42, plugin.receivedArgs?.get("value"))
        assertEquals("call_1", plugin.receivedCallbackId)
    }

    @Test
    fun ignoresUnknownPlugins() {
        val plugin = StubPlugin()
        val config = AppConfiguration(urlString = "https://jasonelle.com")
        val coordinator = Coordinator(config, mapOf("stub" to plugin))

        coordinator.handleMessage("missing", "call_1", emptyMap())

        assertNull(plugin.receivedArgs)
        assertNull(plugin.receivedCallbackId)
    }
}

class RatlogTests {

    @Test
    fun formatsTagsMessageAndSortedFields() {
        val output = Ratlog.format("hello", listOf("b", "a"), mapOf("z" to "1", "a" to "2"))

        assertEquals("[b|a] hello | a: 2 | z: 1", output)
    }

    @Test
    fun omitsEmptyTagsAndFields() {
        assertEquals("hi", Ratlog.format("hi", emptyList(), emptyMap()))
    }

    @Test
    fun omitsTagsOnly() {
        assertEquals("hi | a: 1", Ratlog.format("hi", emptyList(), mapOf("a" to "1")))
        assertEquals("[t] hi", Ratlog.format("hi", listOf("t"), emptyMap()))
    }
}

class LogLevelTests {

    @Test
    fun comparesBySeverity() {
        assertTrue(LogLevel.DEBUG < LogLevel.INFO)
        assertTrue(LogLevel.INFO < LogLevel.NOTICE)
        assertTrue(LogLevel.EMERGENCY > LogLevel.ALERT)
    }
}

class LicenseTests {

    private fun makeLicense(key: String? = "", isSimulator: Boolean): License {
        return License(key = key) { isSimulator }
    }

    @Test
    fun checkWithValidKeyDoesNotCrash() {
        makeLicense(key = "test-key", isSimulator = false).check()
    }

    @Test
    fun checkWithEmptyKeyOnSimulatorDoesNotCrash() {
        makeLicense(isSimulator = true).check()
    }

    @Test
    fun abortReturnsOnSimulator() {
        makeLicense(isSimulator = true).abortIfIsInSimulator()
    }

    @Test
    fun checkWithNilKeyOnSimulatorDoesNotCrash() {
        makeLicense(key = null, isSimulator = true).check()
    }

    @Test
    fun checkWithPurchaseMeKeyOnSimulatorDoesNotCrash() {
        makeLicense(key = "PURCHASE_ME", isSimulator = true).check()
    }

    @Test
    fun checkWithValidKeyOnSimulatorDoesNotCrash() {
        makeLicense(key = "real-key", isSimulator = true).check()
    }

    @Test
    fun checkWithEmptyKeyOnDeviceThrows() {
        try {
            makeLicense(isSimulator = false).check()
            fail("Expected IllegalStateException")
        } catch (_: IllegalStateException) {
            // expected
        }
    }
}

class VersionTests {

    @Test
    fun semanticReturnsTrimmedBundledVersion() {
        val version = Version.semantic()

        assertTrue(version.isNotEmpty())
        assertEquals(version, version.trim())
    }

    @Test
    fun semanticHonorsOverride() {
        Version.version = "9.9.9-test"
        try {
            assertEquals("9.9.9-test", Version.semantic())
        } finally {
            Version.version = null
        }
    }
}

class EventStubPlugin : Plugin() {
    val receivedNames = mutableListOf<String>()

    override fun handle_event(event: String, args: Map<String, Any?>?, respond: (String) -> Unit) {
        receivedNames.add(event)
        respond("")
    }
}

class EventTests {

    @Test
    fun onAppearSendDispatchesToRegisteredPlugins() {
        val plugins: Map<String, Plugin> = mapOf(
            "a" to EventStubPlugin(),
            "b" to EventStubPlugin()
        )
        Events.register(plugins)
        try {
            Events.sendOnAppear()

            val names = plugins.values.map { (it as EventStubPlugin).receivedNames }.flatten()
            assertEquals(2, names.size)
            assertTrue(names.all { it == Events.CONTENT_VIEW_ON_APPEAR.rawValue })
        } finally {
            Events.register(emptyMap())
        }
    }

    @Test
    fun onAppearSendWithNoPluginsIsNoop() {
        Events.register(emptyMap())
        try {
            Events.sendOnAppear()
        } finally {
            Events.register(emptyMap())
        }
    }
}

class UnconfiguredPlugin : Plugin()

class PluginTests {

    @Test
    fun defaultNameIsTypeName() {
        assertEquals("UnconfiguredPlugin", UnconfiguredPlugin().name)
    }

    @Test
    fun defaultCallDoesNotRespond() {
        var response: String? = null

        UnconfiguredPlugin().handle_call("call_1", null) { response = it }

        assertNull(response)
    }

    @Test
    fun defaultEventDoesNotRespond() {
        var response: String? = null

        UnconfiguredPlugin().handle_event("viewDidLoad", null) { response = it }

        assertNull(response)
    }

    @Test
    fun resolveBuildsPromiseScript() {
        var response: String? = null

        UnconfiguredPlugin().resolve(mapOf("message" to "Hello"), "call_1", respond = { response = it })

        assertNotNull(response)
        val script = response ?: return
        assertTrue(script.startsWith("window.jasonelle.result.resolve({"))
        assertTrue(script.contains("\"status\":\"ok\""))
        assertTrue(script.contains("\"callbackId\":\"call_1\""))
        assertTrue(script.contains("\"message\":\"Hello\""))
    }

    @Test
    fun rejectBuildsPromiseScript() {
        var response: String? = null

        UnconfiguredPlugin().reject(mapOf("error" to "nope"), "call_1", status = "error", respond = { response = it })

        assertNotNull(response)
        val script = response ?: return
        assertTrue(script.startsWith("window.jasonelle.result.reject({"))
        assertTrue(script.contains("\"status\":\"error\""))
    }

    @Test
    fun jsLoadsBundledPluginJS() {
        val source = UnconfiguredPlugin().js()

        assertTrue(source.contains("window.jasonelle.plugins.stub"))
    }
}

class NavigationPolicyTests {

    private val mainHost = "jasonelle.com"

    @Test
    fun allowsEveryURLWhenAllowedIsEmptyOrNil() {
        val coordinator = Coordinator(AppConfiguration(urlString = "https://jasonelle.com"), emptyMap())

        assertEquals(NavigationPolicy.ALLOW, coordinator.decidePolicyForHost("anything.com", emptyList(), mainHost))
        assertEquals(NavigationPolicy.ALLOW, coordinator.decidePolicyForHost("anything.com", null, mainHost))
        assertEquals(NavigationPolicy.ALLOW, coordinator.decidePolicyForHost(null, null, mainHost))
    }

    @Test
    fun allowsURLsWhoseHostIsInAllowedList() {
        val coordinator = Coordinator(AppConfiguration(urlString = "https://jasonelle.com"), emptyMap())

        assertEquals(
            NavigationPolicy.ALLOW,
            coordinator.decidePolicyForHost("jasonelle.com", listOf("jasonelle.com"), mainHost)
        )
    }

    @Test
    fun cancelsURLsWhoseHostIsNotInAllowedList() {
        val coordinator = Coordinator(AppConfiguration(urlString = "https://jasonelle.com"), emptyMap())

        assertEquals(
            NavigationPolicy.CANCEL,
            coordinator.decidePolicyForHost("evil.com", listOf("jasonelle.com"), mainHost)
        )
        assertEquals(
            NavigationPolicy.CANCEL,
            coordinator.decidePolicyForHost(null, listOf("jasonelle.com"), mainHost)
        )
    }

    @Test
    fun alwaysAllowsTheAppURL() {
        val coordinator = Coordinator(AppConfiguration(urlString = "https://jasonelle.com"), emptyMap())

        assertEquals(
            NavigationPolicy.ALLOW,
            coordinator.decidePolicyForHost(mainHost, listOf("other.com"), mainHost)
        )
    }
}

class WebViewBridgeTests {

    @Test
    fun bridgePostsReturnPromiseRoutedByCallbackId() {
        val source = JasonelleBridge.JS_BRIDGE_SCRIPT

        assertTrue(source.contains("new Promise"))
        assertTrue(source.contains("callbackId"))
        assertTrue(source.contains("postMessage"))
        assertTrue(source.contains("window.jasonelle"))
    }
}

class ConfigurationLoaderTests {

    @Test
    fun decodeReturnsURLFromValidJSON() {
        val config = ConfigurationLoader.decode("""{"url": "https://example.com"}""")

        assertEquals("https://example.com", config.urlString)
    }

    @Test
    fun decodeStripsJSONCComments() {
        val config = ConfigurationLoader.decode(
            """
            {
              /* block comment */
              "url": "https://example.com", // line comment
              // another comment
              "inspectable": false,
              "allowed": ["example.com"]
            }
            """.trimIndent()
        )

        assertEquals("https://example.com", config.urlString)
        assertEquals(false, config.inspectable)
        assertEquals(listOf("example.com"), config.allowed)
    }

    @Test
    fun decodeThrowsOnInvalidJSON() {
        try {
            ConfigurationLoader.decode("not json")
            fail("Expected ConfigurationException")
        } catch (_: ConfigurationException) {
            // expected
        }
    }

    @Test
    fun stripJSONCCommentsKeepsCommentsInsideStrings() {
        val input = """{"url": "https://example.com/a//b", "note": "not /* a comment */"}"""
        val stripped = ConfigurationLoader.stripJSONCComments(input)

        assertTrue(stripped.contains("https://example.com/a//b"))
        assertTrue(stripped.contains("not /* a comment */"))
    }

    @Test
    fun loadThrowsFileNotFoundWhenStreamIsNull() {
        try {
            ConfigurationLoader.load(null)
            fail("Expected ConfigurationException")
        } catch (_: ConfigurationException) {
            // expected
        }
    }

    @Test
    fun loadReadsConfigStream() {
        val json = """{"url": "https://jasonelle.com"}"""
        val stream = ByteArrayInputStream(json.toByteArray(StandardCharsets.UTF_8))

        val config = ConfigurationLoader.load(stream)

        assertEquals("https://jasonelle.com", config.urlString)
    }
}