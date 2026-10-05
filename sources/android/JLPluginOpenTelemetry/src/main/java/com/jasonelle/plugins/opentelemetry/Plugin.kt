//
//  JLPluginOpenTelemetry/Plugin.kt
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

import android.content.Context
import io.opentelemetry.api.GlobalOpenTelemetry
import com.jasonelle.kernel.Plugin as KernelPlugin

class Plugin(
  context: Context? = null,
) : KernelPlugin(context) {
  override val name: String get() = "opentelemetry"

  override val id: String get() = "com.jasonelle.plugins.opentelemetry"

  override fun handle_call(
    callbackId: String,
    args: Map<String, Any?>?,
    respond: (String) -> Unit,
  ) {
    logger.info("Handling opentelemetry metrics request")

    val action = args?.get("action") as? String
    if (action == null) {
      reject(
        args = mapOf("error" to "No action provided"),
        callbackId = callbackId,
        status = "error",
        respond = respond,
      )
      return
    }

    when (action) {
      "counter.add" -> {
        handleCounterAdd(args)
        resolve(args = mapOf("success" to true), callbackId = callbackId, respond = respond)
      }
      "histogram.record" -> {
        handleHistogramRecord(args)
        resolve(args = mapOf("success" to true), callbackId = callbackId, respond = respond)
      }
      else -> {
        reject(
          args = mapOf("error" to "Unknown action $action"),
          callbackId = callbackId,
          status = "error",
          respond = respond,
        )
      }
    }
  }

  private fun handleCounterAdd(args: Map<String, Any?>) {
    val name = args["name"] as? String ?: return
    val value = (args["value"] as? Number)?.toLong() ?: return

    val meterName = args["meterName"] as? String ?: "jasonelle.app.meter"
    val meter = GlobalOpenTelemetry.get().getMeter(meterName)
    val counter = meter.counterBuilder(name).build()

    // Convert attributes if any

    counter.add(value)
  }

  private fun handleHistogramRecord(args: Map<String, Any?>) {
    val name = args["name"] as? String ?: return
    val value = (args["value"] as? Number)?.toDouble() ?: return

    val meterName = args["meterName"] as? String ?: "jasonelle.app.meter"
    val meter = GlobalOpenTelemetry.get().getMeter(meterName)
    val histogram = meter.histogramBuilder(name).build()

    histogram.record(value)
  }
}
