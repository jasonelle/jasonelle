//
//  JLKernel/Configuration.kt
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
import android.net.Uri
import org.json.JSONObject
import java.io.InputStream

data class AppConfiguration(
  val urlString: String,
  val inspectable: Boolean? = true,
  val allowed: List<String>? = emptyList(),
) {
  constructor(
    url: Uri,
    inspectable: Boolean? = true,
    allowed: List<String>? = emptyList(),
  ) : this(url.toString(), inspectable, allowed)

  val url: Uri get() = Uri.parse(urlString)
}

sealed class ConfigurationException(
  message: String,
  cause: Throwable? = null,
) : Exception(message, cause) {
  class FileNotFound(
    message: String = "Configuration file not found",
  ) : ConfigurationException(message)

  class DecodingError(
    message: String,
    cause: Throwable? = null,
  ) : ConfigurationException(message, cause)
}

object ConfigurationLoader {
  private val logger = Logger(ConfigurationLoader::class.java)

  @JvmStatic
  @Throws(ConfigurationException::class)
  fun load(
    context: Context,
    fileName: String = "config.jsonc",
  ): AppConfiguration {
    val stream: InputStream =
      try {
        context.assets.open(fileName)
      } catch (e: Exception) {
        throw ConfigurationException.FileNotFound("Asset file not found: $fileName")
      }
    return load(stream)
  }

  @JvmStatic
  @Throws(ConfigurationException::class)
  fun load(stream: InputStream?): AppConfiguration {
    if (stream == null) {
      throw ConfigurationException.FileNotFound()
    }
    val text = stream.bufferedReader().use { it.readText() }
    val decoded = decode(text)
    logger.info("Successfully loaded configuration")
    logger.debug(decoded.toString())
    return decoded
  }

  @JvmStatic
  @Throws(ConfigurationException::class)
  fun decode(text: String): AppConfiguration {
    val cleanJson = stripJSONCComments(text)
    try {
      val json = JSONObject(cleanJson)
      val urlString = json.getString("url")
      val inspectable = if (json.has("inspectable")) json.optBoolean("inspectable", true) else null
      val allowedList =
        if (json.has("allowed") && !json.isNull("allowed")) {
          val arr = json.getJSONArray("allowed")
          val list = mutableListOf<String>()
          for (i in 0 until arr.length()) {
            list.add(arr.getString(i))
          }
          list
        } else {
          null
        }
      return AppConfiguration(
        urlString = urlString,
        inspectable = inspectable,
        allowed = allowedList,
      )
    } catch (e: Exception) {
      throw ConfigurationException.DecodingError("Failed to decode configuration: ${e.message}", e)
    }
  }

  /**
   * Strips single-line (//) and multi-line (/* */) comments outside quoted strings.
   */
  @JvmStatic
  fun stripJSONCComments(text: String): String {
    val result = StringBuilder()
    var i = 0
    var inString = false
    var escaped = false
    val len = text.length

    while (i < len) {
      val c = text[i]

      if (escaped) {
        escaped = false
        result.append(c)
        i++
        continue
      }

      if (c == '\\' && inString) {
        escaped = true
        result.append(c)
        i++
        continue
      }

      if (c == '"') {
        inString = !inString
        result.append(c)
        i++
        continue
      }

      if (!inString && c == '/') {
        val next = if (i + 1 < len) text[i + 1] else ' '
        if (next == '/') {
          // Line comment: skip until newline or EOF
          val newlineIdx = text.indexOf('\n', i)
          i = if (newlineIdx != -1) newlineIdx else len
          continue
        } else if (next == '*') {
          // Block comment: skip until */
          val endIdx = text.indexOf("*/", i + 2)
          i = if (endIdx != -1) endIdx + 2 else len
          continue
        }
      }

      result.append(c)
      i++
    }

    return result.toString()
  }
}
