//
//  JLPluginOpenTelemetryTests/JLPluginOpenTelemetryTests.kt
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

package com.jasonelle.plugins.opentelemetry

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class JLPluginOpenTelemetryTests {
  @Test
  fun exposesNameAndId() {
    val plugin = Plugin()

    assertEquals("opentelemetry", plugin.name)
    assertEquals("com.jasonelle.plugins.opentelemetry", plugin.id)
  }

  @Test
  fun handle_call_nullArgs_rejectsWithNoActionProvided() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("call_1", null) { response = it }

    val script = response ?: ""
    assertTrue(script.startsWith("window.jasonelle.result.reject({"))
    assertTrue(script.contains("\"status\":\"error\""))
    assertTrue(script.contains("\"callbackId\":\"call_1\""))
    assertTrue(script.contains("\"error\":\"No action provided\""))
  }

  @Test
  fun handle_call_emptyArgs_rejectsWithNoActionProvided() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("call_1", emptyMap()) { response = it }

    val script = response ?: ""
    assertTrue(script.startsWith("window.jasonelle.result.reject({"))
    assertTrue(script.contains("\"error\":\"No action provided\""))
  }

  @Test
  fun handle_call_counterAdd_resolvesSuccess() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call(
      "call_1",
      mapOf("action" to "counter.add", "name" to "button_clicks", "value" to 1),
    ) { response = it }

    val script = response ?: ""
    assertTrue(script.startsWith("window.jasonelle.result.resolve({"))
    assertTrue(script.contains("\"status\":\"ok\""))
    assertTrue(script.contains("\"callbackId\":\"call_1\""))
    assertTrue(script.contains("\"success\":true"))
  }

  @Test
  fun handle_call_counterAddMissingName_stillResolvesSuccess() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call(
      "call_1",
      mapOf("action" to "counter.add", "value" to 1),
    ) { response = it }

    assertTrue((response ?: "").contains("\"success\":true"))
  }

  @Test
  fun handle_call_counterAddNonNumericValue_stillResolvesSuccess() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call(
      "call_1",
      mapOf("action" to "counter.add", "name" to "button_clicks", "value" to "one"),
    ) { response = it }

    assertTrue((response ?: "").contains("\"success\":true"))
  }

  @Test
  fun handle_call_histogramRecord_resolvesSuccess() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call(
      "call_1",
      mapOf(
        "action" to "histogram.record",
        "name" to "load_time_ms",
        "value" to 124.5,
        "meterName" to "jasonelle.app.meter",
      ),
    ) { response = it }

    val script = response ?: ""
    assertTrue(script.startsWith("window.jasonelle.result.resolve({"))
    assertTrue(script.contains("\"status\":\"ok\""))
    assertTrue(script.contains("\"success\":true"))
  }

  @Test
  fun handle_call_histogramRecordMissingName_stillResolvesSuccess() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call(
      "call_1",
      mapOf("action" to "histogram.record", "value" to 124.5),
    ) { response = it }

    assertTrue((response ?: "").contains("\"success\":true"))
  }

  @Test
  fun handle_call_unknownAction_rejectsWithError() {
    val plugin = Plugin()
    var response: String? = null

    plugin.handle_call("call_1", mapOf("action" to "gauge.record")) { response = it }

    val script = response ?: ""
    assertTrue(script.startsWith("window.jasonelle.result.reject({"))
    assertTrue(script.contains("\"status\":\"error\""))
    assertTrue(script.contains("\"error\":\"Unknown action gauge.record\""))
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
    assertTrue(js.contains("window.jasonelle.plugins.opentelemetry"))
    assertTrue(js.contains("counter.add"))
    assertTrue(js.contains("histogram.record"))
  }
}
