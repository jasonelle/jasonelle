//
//  JLPluginDeviceTests/JLPluginDeviceTests.kt
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

package com.jasonelle.plugins.device

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class JLPluginDeviceTests {

    @Test
    fun exposesNameAndId() {
        val plugin = Plugin()

        assertEquals("device", plugin.name)
        assertEquals("com.jasonelle.plugins.device", plugin.id)
    }

    @Test
    fun callRespondsWithDeviceInfoScript() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_call("call_1", null) { response = it }

        val script = response ?: ""
        assertTrue(script.startsWith("window.jasonelle.result.resolve({"))
        assertTrue(script.contains("\"status\":\"ok\""))
        assertTrue(script.contains("\"callbackId\":\"call_1\""))
        assertTrue(script.contains("\"vendor\":\"google\""))
        assertTrue(script.contains("\"os\":{"))
        assertTrue(script.contains("\"name\":\"android\""))
        assertTrue(script.contains("\"type\":\""))
        assertTrue(script.contains("\"orientation\":\""))
        assertTrue(script.contains("\"screen\":{"))
        assertTrue(script.contains("\"width\":"))
        assertTrue(script.contains("\"height\":"))
    }

    @Test
    fun deviceInfoRepresentsAndroidMetadata() {
        val info = Plugin().deviceInfo()

        assertEquals("android", (info["os"] as Map<*, *>)["name"])
        assertEquals("google", info["vendor"])
        assertNotNull(info["os"] as? Map<*, *>)
        assertEquals("unknown", (info["os"] as Map<*, *>)["version"] ?: "unknown")
    }

    @Test
    fun eventWithoutHandlerDoesNotRespond() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_event("onAppear", null) { response = it }

        assertNull(response)
    }

    @Test
    fun bundlesJavaScriptRegisteringPlugin() {
        val js = Plugin().js()

        assertTrue(js.isNotEmpty())
        assertTrue(js.contains("window.jasonelle.plugins.device"))
    }
}