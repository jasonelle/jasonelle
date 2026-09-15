//
//  JLKernel/Plugin.kt
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

import android.content.Context
import android.webkit.WebView
import org.json.JSONArray
import org.json.JSONObject

open class Plugin(val context: Context? = null) {
    /**
     * The name is the key inside the plugin object in JS.
     */
    open val name: String
        get() = this::class.java.simpleName

    /**
     * The id must follow reverse domain notation, e.g. com.jasonelle.plugins.<name>
     */
    open val id: String
        get() = "com.jasonelle.plugins.$name"

    val logger: Logger by lazy { Logger("Plugin.$name") }

    /**
     * Native handler invoked when JS calls this plugin through the bridge.
     * Call [respond] with the JavaScript script string to evaluate.
     */
    open fun handle_call(callbackId: String, args: Map<String, Any?>? = emptyMap(), respond: (String) -> Unit) {
        logger.notice("Plugin $name has no native call handler implemented")
    }

    /**
     * Native handler invoked when a native event is triggered (e.g. ContentView.onAppear).
     */
    open fun handle_event(event: String, args: Map<String, Any?>? = emptyMap(), respond: (String) -> Unit) {
        logger.notice("Plugin $name has no native event handler implemented for $event")
    }

    fun resolve(
        args: Map<String, Any?> = emptyMap(),
        callbackId: String,
        status: String = "ok",
        respond: (String) -> Unit
    ) {
        try {
            val response = mutableMapOf<String, Any?>(
                "status" to status,
                "callbackId" to callbackId
            )
            response.putAll(args)

            logger.debug("resolve: Sending response: $response")

            val json = mapToJson(response).toString()
            val js = "window.jasonelle.result.resolve($json);"
            respond(js)
        } catch (e: Exception) {
            logger.notice("Failed to convert map to JSON: ${e.message}")
        }
    }

    fun reject(
        args: Map<String, Any?> = emptyMap(),
        callbackId: String,
        status: String = "error",
        respond: (String) -> Unit
    ) {
        try {
            val response = mutableMapOf<String, Any?>(
                "status" to status,
                "callbackId" to callbackId
            )
            response.putAll(args)

            logger.debug("reject: Sending response: $response")

            val json = mapToJson(response).toString()
            val js = "window.jasonelle.result.reject($json);"
            respond(js)
        } catch (e: Exception) {
            logger.notice("Failed to convert map to JSON: ${e.message}")
        }
    }

    fun event(
        event: String,
        plugin: String,
        args: Map<String, Any?> = emptyMap(),
        status: String = "ok",
        respond: (String) -> Unit
    ) {
        try {
            val response = mutableMapOf<String, Any?>(
                "status" to status,
                "event" to event,
                "plugin" to plugin
            )
            response.putAll(args)

            logger.debug("Sending event: $response")

            val json = mapToJson(response).toString()
            val js = "window.jasonelle.plugins.$plugin.handle($json);"
            respond(js)
        } catch (e: Exception) {
            logger.notice("Failed to convert map to JSON: ${e.message}")
        }
    }

    /**
     * Loads the bundled Plugin.js script for this plugin.
     *
     * Each plugin library ships its script at `src/main/assets/plugins/<name>/Plugin.js`
     * (a per-plugin path, since all library assets are merged into the app's single
     * `assets/` folder at build time). A root `Plugin.js` in the app itself overrides it.
     */
    open fun js(): String {
        // Try assets first if context available
        if (context != null) {
            try {
                return context.assets.open("plugins/$name/Plugin.js").bufferedReader().use { it.readText() }.trim()
            } catch (_: Exception) {}

            try {
                return context.assets.open("Plugin.js").bufferedReader().use { it.readText() }.trim()
            } catch (_: Exception) {}
        }

        // Try classpath resources
        try {
            val stream = this::class.java.getResourceAsStream("/plugins/$name/Plugin.js")
                ?: this::class.java.getResourceAsStream("/Plugin.js")
                ?: this::class.java.classLoader?.getResourceAsStream("plugins/$name/Plugin.js")
                ?: this::class.java.classLoader?.getResourceAsStream("Plugin.js")
            stream?.bufferedReader()?.use { return it.readText().trim() }
        } catch (_: Exception) {}

        return ""
    }

    fun inject(into: WebView) {
        logger.info("Injecting plugin $name into webview")
        val script = js()
        if (script.isNotEmpty()) {
            logger.debug(script)
            into.post {
                into.evaluateJavascript(script, null)
            }
        }
    }

    companion object {
        @JvmStatic
        fun inject(plugins: Map<String, Plugin>, into: WebView) {
            Logger(Plugin::class.java).debug("Injecting ${plugins.size} plugins into webview")
            for ((_, plugin) in plugins) {
                plugin.inject(into)
            }
        }

        @Suppress("UNCHECKED_CAST")
        fun mapToJson(map: Map<String, Any?>): JSONObject {
            val obj = JSONObject()
            for ((key, value) in map) {
                when (value) {
                    null -> obj.put(key, JSONObject.NULL)
                    is Map<*, *> -> obj.put(key, mapToJson(value as Map<String, Any?>))
                    is List<*> -> obj.put(key, listToJson(value))
                    else -> obj.put(key, value)
                }
            }
            return obj
        }

        @Suppress("UNCHECKED_CAST")
        private fun listToJson(list: List<*>): JSONArray {
            val arr = JSONArray()
            for (item in list) {
                when (item) {
                    null -> arr.put(JSONObject.NULL)
                    is Map<*, *> -> arr.put(mapToJson(item as Map<String, Any?>))
                    is List<*> -> arr.put(listToJson(item))
                    else -> arr.put(item)
                }
            }
            return arr
        }
    }
}
