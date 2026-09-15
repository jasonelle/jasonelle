//
//  JLPluginCookiesTests/JLPluginCookiesTests.kt
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

package com.jasonelle.plugins.cookies

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class JLPluginCookiesTests {

    @Test
    fun exposesNameAndId() {
        val plugin = Plugin()

        assertEquals("cookies", plugin.name)
        assertEquals("com.jasonelle.plugins.cookies", plugin.id)
    }

    @Test
    fun saveRespondsWithOkScript() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_call("call_1", mapOf("action" to "save", "value" to "session=abc")) { response = it }

        assertTrue((response ?: "").startsWith("window.jasonelle.result.resolve({"))
        assertTrue((response ?: "").contains("\"status\":\"ok\""))
        assertTrue((response ?: "").contains("\"callbackId\":\"call_1\""))
    }

    @Test
    fun restoreRespondsWithValueScript() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_call("call_2", mapOf("action" to "restore")) { response = it }

        assertTrue((response ?: "").startsWith("window.jasonelle.result.resolve({"))
        assertTrue((response ?: "").contains("\"value\":\""))
    }

    @Test
    fun saveWithoutValueRespondsWithRejectScript() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_call("call_1", mapOf("action" to "save")) { response = it }

        assertTrue((response ?: "").startsWith("window.jasonelle.result.reject({"))
        assertTrue((response ?: "").contains("\"status\":\"error\""))
        assertTrue((response ?: "").contains("\"error\":\"Missing 'value'\""))
    }

    @Test
    fun unknownActionRespondsWithRejectScript() {
        val plugin = Plugin()
        var response: String? = null

        plugin.handle_call("call_1", null) { response = it }

        assertTrue((response ?: "").startsWith("window.jasonelle.result.reject({"))
        assertTrue((response ?: "").contains("\"status\":\"error\""))
    }

    @Test
    fun bundlesJavaScriptRegisteringPlugin() {
        val js = Plugin().js()

        assertTrue(js.isNotEmpty())
        assertTrue(js.contains("window.jasonelle.plugins.cookies"))
    }
}