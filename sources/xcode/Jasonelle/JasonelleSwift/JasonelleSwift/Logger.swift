//
//  Logger.swift
//  JLKernel
//
//  Created by clsource on 06-02-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  https://mozilla.org/MPL/2.0/.
//

import Foundation
import Jasonelle

/// A simple wrapper around Objective-C Logger
/// to ease using it in Swift code
public struct Logger {
    var app = Jasonelle.App.instance
    var logger = Jasonelle.App.instance.logger

    public init() {}

    public init(_ logger: JLLoggerProtocol) {
        self.logger = logger
    }

    public func trace(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.trace(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func debug(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.debug(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func info(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.info(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func notice(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.notice(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func warning(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.warning(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func error(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.error(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }

    public func critical(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.critical(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }
}
