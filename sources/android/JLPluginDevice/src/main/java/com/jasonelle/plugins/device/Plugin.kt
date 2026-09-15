//
//  JLPluginDevice/Plugin.kt
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

import android.content.Context
import android.content.res.Configuration
import android.os.Build
import com.jasonelle.kernel.Plugin as KernelPlugin

class Plugin(context: Context? = null) : KernelPlugin(context) {
    override val name: String get() = "device"

    override val id: String get() = "com.jasonelle.plugins.device"

    override fun handle_call(callbackId: String, args: Map<String, Any?>?, respond: (String) -> Unit) {
        logger.info("Handling device info request")
        resolve(args = deviceInfo(), callbackId = callbackId, respond = respond)
    }

    internal fun deviceInfo(): Map<String, Any?> {
        return mapOf(
            "os" to mapOf("name" to "android", "version" to osVersion()),
            "vendor" to "google",
            "type" to deviceType(),
            "orientation" to orientation(),
            "screen" to mapOf("width" to screenWidth(), "height" to screenHeight())
        )
    }

    private fun osVersion(): String {
        // Build.VERSION fields are static, so this is safe to read in local JVM tests.
        return Build.VERSION.RELEASE ?: "unknown"
    }

    private fun deviceType(): String {
        val resources = context?.resources ?: return "phone"
        val isTablet = resources.configuration.smallestScreenWidthDp >= 600
        return if (isTablet) "tablet" else "phone"
    }

    private fun orientation(): String {
        val resources = context?.resources ?: return "unknown"
        return when (resources.configuration.orientation) {
            Configuration.ORIENTATION_PORTRAIT -> "portrait"
            Configuration.ORIENTATION_LANDSCAPE -> "landscape"
            else -> "unknown"
        }
    }

    private fun screenWidth(): Int {
        return context?.resources?.displayMetrics?.widthPixels ?: 0
    }

    private fun screenHeight(): Int {
        return context?.resources?.displayMetrics?.heightPixels ?: 0
    }
}