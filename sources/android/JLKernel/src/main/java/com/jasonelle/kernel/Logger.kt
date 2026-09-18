//
//  JLKernel/Logger.kt
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

import android.util.Log

/**
 * Log levels ordered by severity. Higher value = more severe.
 */
enum class LogLevel(
  val value: Int,
) : Comparable<LogLevel> {
  DEBUG(0),
  INFO(1),
  NOTICE(2),
  WARNING(3),
  ERROR(4),
  CRITICAL(5),
  ALERT(6),
  EMERGENCY(7),
  ;

  companion object {
    fun fromValue(value: Int): LogLevel = entries.firstOrNull { it.value == value } ?: DEBUG
  }
}

/**
 * Ratlog format encoder. Handles line construction per spec.
 * See: https://github.com/ratlog/ratlog-spec
 */
object Ratlog {
  @JvmStatic
  fun format(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ): String {
    val sb = StringBuilder()

    if (tags.isNotEmpty()) {
      sb.append("[").append(tags.joinToString("|")).append("] ")
    }

    sb.append(message)

    if (fields.isNotEmpty()) {
      for (key in fields.keys.sorted()) {
        sb
          .append(" | ")
          .append(key)
          .append(": ")
          .append(fields[key] ?: "")
      }
    }

    return sb.toString()
  }
}

/**
 * Logger for Jasonelle using Ratlog format.
 */
class Logger {
  val subsystem: String
  val category: String

  companion object {
    @JvmStatic
    var level: LogLevel = LogLevel.DEBUG

    /**
     * Custom log emitter for testing or redirection.
     * If null, delegates to android.util.Log / System.out.
     */
    @JvmStatic
    var customEmitter: ((LogLevel, String, String) -> Unit)? = null
  }

  constructor(subsystem: String = "com.jasonelle", category: String = "default") {
    this.subsystem = subsystem
    this.category = category
  }

  constructor(from: Any, category: String = "default") {
    this.subsystem = if (from is Class<*>) from.simpleName else from::class.java.simpleName
    this.category = category
  }

  fun debug(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.DEBUG, "debug", message, tags, fields)
  }

  fun info(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.INFO, "info", message, tags, fields)
  }

  fun notice(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.NOTICE, "notice", message, tags, fields)
  }

  fun warning(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.WARNING, "warning", message, tags, fields)
  }

  fun error(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.ERROR, "error", message, tags, fields)
  }

  fun critical(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.CRITICAL, "critical", message, tags, fields)
  }

  fun emergency(
    message: String,
    tags: List<String> = emptyList(),
    fields: Map<String, String> = emptyMap(),
  ) {
    log(LogLevel.EMERGENCY, "emergency", message, tags, fields)
  }

  private fun log(
    msgLevel: LogLevel,
    tag: String,
    message: String,
    tags: List<String>,
    fields: Map<String, String>,
  ) {
    if (level > msgLevel) return

    val formatted = Ratlog.format(message, listOf(subsystem, tag) + tags, fields)
    val tagLabel = subsystem.take(23) // Android tag limit safe

    val emitter = customEmitter
    if (emitter != null) {
      emitter(msgLevel, tagLabel, formatted)
      return
    }

    try {
      when (msgLevel) {
        LogLevel.DEBUG -> Log.d(tagLabel, formatted)
        LogLevel.INFO, LogLevel.NOTICE -> Log.i(tagLabel, formatted)
        LogLevel.WARNING -> Log.w(tagLabel, formatted)
        LogLevel.ERROR, LogLevel.CRITICAL, LogLevel.ALERT, LogLevel.EMERGENCY -> Log.e(tagLabel, formatted)
      }
    } catch (_: Exception) {
      // In pure JVM unit tests without android.util.Log available, fallback to stdout/stderr
      if (msgLevel >= LogLevel.ERROR) {
        System.err.println("[$tagLabel] $formatted")
      } else {
        println("[$tagLabel] $formatted")
      }
    }
  }
}
