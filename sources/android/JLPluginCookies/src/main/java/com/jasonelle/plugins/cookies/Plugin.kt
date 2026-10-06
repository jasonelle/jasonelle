//
//  JLPluginCookies/Plugin.kt
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

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import com.jasonelle.kernel.Plugin as KernelPlugin

class Plugin(
  context: Context? = null,
) : KernelPlugin(context) {
  override val name: String get() = "cookies"

  override val id: String get() = "com.jasonelle.plugins.cookies"

  override fun handle_call(
    callbackId: String,
    args: Map<String, Any?>?,
    respond: (String) -> Unit,
  ) {
    when (args?.get("action") as? String) {
      "save" -> {
        val value = args?.get("value") as? String
        if (value == null) {
          reject(
            args = mapOf("error" to "Missing 'value'"),
            callbackId = callbackId,
            status = "error",
            respond = respond,
          )
          return
        }
        save(value)
        resolve(args = mapOf("status" to "ok"), callbackId = callbackId, respond = respond)
      }

      "restore" -> {
        resolve(args = mapOf("value" to (restore() ?: "")), callbackId = callbackId, respond = respond)
      }

      else -> {
        reject(
          args = mapOf("error" to "Unknown action"),
          callbackId = callbackId,
          status = "error",
          respond = respond,
        )
      }
    }
  }

  /**
   * Stores the cookie string in encrypted preferences under the "cookie" key.
   * When no context is available (JVM unit tests) it is a no-op.
   */
  private fun save(value: String) {
    val prefs = encryptedPreferences() ?: return
    prefs.edit().putString("cookie", value).apply()
  }

  /**
   * Reads the stored cookie string from encrypted preferences.
   */
  private fun restore(): String? {
    val prefs = encryptedPreferences() ?: return null
    return prefs.getString("cookie", null)
  }

  private fun encryptedPreferences(): SharedPreferences? {
    val ctx =
      context ?: run {
        logger.warning("No context available, cookie storage is disabled")
        return null
      }
    return try {
      val masterKey =
        MasterKey
          .Builder(ctx)
          .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
          .build()
      EncryptedSharedPreferences.create(
        ctx,
        "com.jasonelle.plugins.cookies",
        masterKey,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
      )
    } catch (e: Exception) {
      logger.warning("Failed to initialize cookie storage: ${e.message}")
      null
    }
  }
}
