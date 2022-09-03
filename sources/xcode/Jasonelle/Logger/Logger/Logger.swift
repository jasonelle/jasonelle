//
//  Logger.swift
//  Logger
//
//  Created by clsource on 06-02-22
//
//  Copyright (c) 2022 ___ORGANIZATIONNAME___
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
/// to ease using it in swift code
public struct Logger {
    var logger: JLLoggerProtocol

    func trace(_ message: String, file: String? = #file, function: String? = #function, line: Int? = #line) {
        logger.trace(message, file: (file as NSString?)?.lastPathComponent, function: function, line: line as NSNumber?)
    }
}
