//
//  JLPluginHello/Plugin.kt
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

import android.content.Context
import com.jasonelle.kernel.Plugin as KernelPlugin

class Plugin(context: Context? = null) : KernelPlugin(context) {
    override val name: String get() = "hello"

    override val id: String get() = "com.jasonelle.plugins.hello"

    override fun handle_call(callbackId: String, args: Map<String, Any?>?, respond: (String) -> Unit) {
        logger.info("Handled in native code with args: $args")

        when (args?.get("action") as? String) {
            "hello" -> {
                logger.info("Resolved with hello response")
                hello()
                resolve(args = mapOf("status" to "ok"), callbackId = callbackId, respond = respond)
            }

            "world" -> {
                logger.info("Resolved with world response")
                val value = args["args"] as? String
                if (value == null) {
                    reject(
                        args = mapOf("error" to "Missing 'value'"),
                        callbackId = callbackId,
                        status = "error",
                        respond = respond
                    )
                    return
                }
                resolve(args = mapOf("value" to world(value)), callbackId = callbackId, respond = respond)
            }

            else -> {
                logger.info("Resolved with default response")
                resolve(args = args ?: emptyMap(), callbackId = callbackId, respond = respond)
            }
        }
    }

    override fun handle_event(event: String, args: Map<String, Any?>?, respond: (String) -> Unit) {
        logger.debug("Handled event $event in native code with args: $args")

        event(event, plugin = name, args = args ?: emptyMap(), respond = respond)
    }

    private fun hello() {
        logger.notice("Hello, world!")
    }

    private fun world(value: String): String {
        logger.notice("Hello, world! => $value")
        return value
    }
}