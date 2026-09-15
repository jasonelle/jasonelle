//
//  JLKernel/License.kt
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

import android.os.Build

class License(
    private val key: String? = null,
    private val isInSimulator: () -> Boolean = { isRunningInEmulator() }
) {
    private val logger = Logger(License::class.java)

    companion object {
        @JvmStatic
        fun isRunningInEmulator(): Boolean {
            return (Build.FINGERPRINT.startsWith("generic")
                    || Build.FINGERPRINT.startsWith("unknown")
                    || Build.MODEL.contains("google_sdk")
                    || Build.MODEL.contains("Emulator")
                    || Build.MODEL.contains("Android SDK built for x86")
                    || Build.MANUFACTURER.contains("Genymotion")
                    || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                    || "google_sdk" == Build.PRODUCT
                    || Build.HARDWARE.contains("goldfish")
                    || Build.HARDWARE.contains("ranchu"))
        }

        @JvmStatic
        fun verify(key: String? = "") {
            val license = License(key)
            license.check()
        }
    }

    private fun isValid(): Boolean {
        val k = key
        val isEmpty = k?.isEmpty() == true
        val isBlank = k?.trim() == ""
        return !(k == null || isEmpty || isBlank || k == "PURCHASE_ME")
    }

    fun abortIfIsInSimulator() {
        if (isInSimulator()) {
            if (!isValid()) {
                logger.info("Running in simulator. Please consider purchasing a license at https://jasonelle.com")
            }
            return
        }
        val error = "License is not set. Running in Device is not allowed without a license. Can only use in simulator. Adquire an official license at https://jasonelle.com"
        logger.emergency(error)
        throw IllegalStateException(error)
    }

    fun check() {
        if (isValid()) {
            logger.info("License found. Thank you for supporting Jasonelle development ♥.")
            return
        }
        abortIfIsInSimulator()
    }
}
