//
//  JLKernel/Logger.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-26
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

import Foundation
import os

/// Log levels ordered by severity. Higher value = more severe.
///
/// When the minimum level is set to a given value, only that level and above are printed.
/// For example, `.info` passes `.info`, `.notice`, `.warning`, `.error`, `.critical`,
/// `.alert`, and `.emergency` to handlers, but discards `.debug`.
public enum LogLevel: Int, Comparable {
    /// For debug-related messages.
    case debug = 0
    /// For information of any kind.
    case info = 1
    /// For normal, but significant, messages.
    case notice = 2
    /// For warnings.
    case warning = 3
    /// For errors.
    case error = 4
    /// For critical conditions.
    case critical = 5
    /// For alerts, actions that must be taken immediately (e.g. corrupted database).
    case alert = 6
    /// When the system is unusable, panics.
    case emergency = 7

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public class Logger {
  public let subsystem: String
  public let logger: os.Logger

  public static var level: LogLevel = .debug

  /// Creates a logger with the default subsystem.
  public init() {
    self.subsystem = "com.jasonelle"
    self.logger = os.Logger(subsystem: self.subsystem, category: "default")
  }

  /// Creates a logger with a custom subsystem and optional category.
  public init(_ subsystem: String, category: String = "default") {
    self.subsystem = subsystem
    self.logger = os.Logger(subsystem: self.subsystem, category: category)
  }

  /// Creates a logger using the type name as subsystem.
  public init(from: Any, category: String = "default") {
    self.subsystem = String(describing: from)
    self.logger = os.Logger(subsystem: self.subsystem, category: category)
  }

  public func debug(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .debug, tag: "debug", message: message, context: (tags, fields)) { self.logger.debug("\($0)") }
  }

  public func info(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .info, tag: "info", message: message, context: (tags, fields)) { self.logger.info("\($0)") }
  }

  public func notice(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .notice, tag: "notice", message: message, context: (tags, fields)) { self.logger.notice("\($0)") }
  }

  public func warning(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .warning, tag: "warning", message: message, context: (tags, fields)) { self.logger.warning("\($0)") }
  }

  public func error(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .error, tag: "error", message: message, context: (tags, fields)) { self.logger.error("\($0)") }
  }

  public func critical(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .critical, tag: "critical", message: message, context: (tags, fields)) { self.logger.critical("\($0)") }
  }

  public func emergency(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .emergency, tag: "emergency", message: message, context: (tags, fields)) { self.logger.fault("\($0)") }
  }

  private func log(
    level: LogLevel, tag: String, message: String,
    context: ([String], [String: String]),
    emit: (String) -> Void
  ) {
    guard Logger.level <= level else { return }
    let (tags, fields) = context
    emit(Ratlog.format(message: message, tags: [self.subsystem, tag] + tags, fields: fields))
  }

}

/// Ratlog format encoder. Handles escaping and line construction per spec.
/// See: https://github.com/ratlog/ratlog-spec
public enum Ratlog {
  public static func format(message: String, tags: [String], fields: [String: String]) -> String {
    var result = ""

    if !tags.isEmpty {
      result += "[" + tags.joined(separator: "|") + "] "
    }

    result += message

    if !fields.isEmpty {
      for key in fields.keys.sorted() {
        result += " | " + key + ": " + (fields[key] ?? "")
      }
    }

    return result
  }
}
