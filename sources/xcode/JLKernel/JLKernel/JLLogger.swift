//
//  Logger.swift
//  Kernel
//
//  Created by Camilo on 18-08-26.
//

import Foundation
import os


/// Log levels ordered by severity. Higher value = more severe.
///
/// When the minimum level is set to a given value, only that level and above are printed.
/// For example, `.info` passes `.info`, `.notice`, `.warning`, `.error`, `.critical`,
/// `.alert`, and `.emergency` to handlers, but discards `.debug`.
public enum JLLogLevel: Int, Comparable {
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
    
    public static func < (lhs: JLLogLevel, rhs: JLLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public class Logger {
  public let subsystem: String
  public let logger: os.Logger
  
  public static var level : JLLogLevel = .debug
  
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
    log(level: .debug, tag: "debug", message: message, tags: tags, fields: fields) { self.logger.debug("\($0)") }
  }

  public func info(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .info, tag: "info", message: message, tags: tags, fields: fields) { self.logger.info("\($0)") }
  }

  public func notice(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .notice, tag: "notice", message: message, tags: tags, fields: fields) { self.logger.notice("\($0)") }
  }

  public func warning(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .warning, tag: "warning", message: message, tags: tags, fields: fields) { self.logger.warning("\($0)") }
  }

  public func error(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .error, tag: "error", message: message, tags: tags, fields: fields) { self.logger.error("\($0)") }
  }

  public func critical(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .critical, tag: "critical", message: message, tags: tags, fields: fields) { self.logger.critical("\($0)") }
  }

  public func emergency(_ message: String, tags: [String] = [], fields: [String: String] = [:]) {
    log(level: .emergency, tag: "emergency", message: message, tags: tags, fields: fields) { self.logger.fault("\($0)") }
  }

  private func log(level: JLLogLevel, tag: String, message: String, tags: [String], fields: [String: String], emit: (String) -> Void) {
    guard Logger.level <= level else { return }
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
