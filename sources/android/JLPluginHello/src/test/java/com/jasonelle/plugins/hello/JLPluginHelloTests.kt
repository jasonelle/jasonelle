//
//  JLPluginHelloTests/JLPluginHelloTests.kt
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

package com.jasonelle.plugins.hello

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class JLPluginHelloTests {
  @Test
  fun exposesNameAndId() {
    val plugin = Plugin()

    assertEquals("hello", plugin.name)
    assertEquals("com.jasonelle.plugins.hello", plugin.id)
  }

  @Test
  fun defaultCallResolvesWithArgs() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("call_1", mapOf("message" to "Hello")) { response = it }

    assertTrue((response ?: "").startsWith("window.jasonelle.result.resolve({"))
    assertTrue((response ?: "").contains("\"status\":\"ok\""))
    assertTrue((response ?: "").contains("\"callbackId\":\"call_1\""))
    assertTrue((response ?: "").contains("\"message\":\"Hello\""))
  }

  @Test
  fun helloActionResolves() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("c_hello", mapOf("action" to "hello")) { response = it }

    assertTrue((response ?: "").startsWith("window.jasonelle.result.resolve({"))
    assertTrue((response ?: "").contains("\"status\":\"ok\""))
    assertTrue((response ?: "").contains("\"callbackId\":\"c_hello\""))
  }

  @Test
  fun worldActionResolvesWithValue() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("c_world", mapOf("action" to "world", "args" to "Jasonelle")) { response = it }

    assertTrue((response ?: "").startsWith("window.jasonelle.result.resolve({"))
    assertTrue((response ?: "").contains("\"value\":\"Jasonelle\""))
    assertTrue((response ?: "").contains("\"callbackId\":\"c_world\""))
  }

  @Test
  fun worldActionRejectsWhenArgsMissing() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("c_world_err", mapOf("action" to "world")) { response = it }

    assertTrue((response ?: "").startsWith("window.jasonelle.result.reject({"))
    assertTrue((response ?: "").contains("\"status\":\"error\""))
  }

  @Test
  fun eventRespondsWithHandleScript() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_event("viewDidLoad", null) { response = it }

    assertTrue((response ?: "").contains("window.jasonelle.plugins.hello.handle("))
    assertTrue((response ?: "").contains("\"event\":\"viewDidLoad\""))
    assertTrue((response ?: "").contains("\"plugin\":\"hello\""))
    assertTrue((response ?: "").contains("\"status\":\"ok\""))
  }

  @Test
  fun eventPassesArgsThrough() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_event("onAppear", mapOf("key" to "val")) { response = it }

    assertTrue((response ?: "").contains("window.jasonelle.plugins.hello.handle("))
    assertTrue((response ?: "").contains("\"key\":\"val\""))
  }

  @Test
  fun bundlesJavaScriptRegisteringPlugin() {
    val js = Plugin().js()

    assertNotNull(js)
    assertTrue(js.isNotEmpty())
    assertTrue(js.contains("window.jasonelle.plugins.hello"))
    assertTrue(js.contains("plugin.hello"))
    assertTrue(js.contains("plugin.world"))
  }
}
