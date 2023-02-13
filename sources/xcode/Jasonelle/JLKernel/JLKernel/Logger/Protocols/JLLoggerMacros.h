//
//  JLLoggerMacros.h
//  JLKernel
//
//  Created by clsource on 04-05-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//

// Helper Macros

/// Joins objects in a single string
#define jlog_join(...) \
    [@[__VA_ARGS__] componentsJoinedByString:@""]

/// Shortcut to [NSString stringWithFormat:]
#define jlog_fmt(fmt, ...) \
    [NSString stringWithFormat:fmt, __VA_ARGS__]

/// Converts boolean to a YES or NO string
#define jlog_b2s(boolean) (boolean ? @"YES" : @"NO")

// Trace
#define jlog_logger_trace(logger, message) \
    [logger trace:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_trace_join(logger, ...) \
    jlog_logger_trace(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_trace_fmt(logger, fmt, ...) \
    jlog_logger_trace(logger, jlog_fmt(fmt, __VA_ARGS__))

// instance
#define jlog_trace(message) \
    jlog_logger_trace(self.logger, message)

#define jlog_trace_join(...) \
    jlog_logger_trace_join(self.logger, __VA_ARGS__)

#define jlog_trace_fmt(fmt, ...) \
    jlog_logger_trace_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_trace(message) \
    jlog_logger_trace([JLApplication instance].logger, message)

#define jlog_global_trace_join(...) \
    jlog_logger_trace_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_trace_fmt(fmt, ...) \
    jlog_logger_trace_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Debug
#define jlog_logger_debug(logger, message) \
    [logger debug:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_debug_join(logger, ...) \
    jlog_logger_debug(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_debug_fmt(logger, fmt, ...) \
    jlog_logger_debug(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_debug(message) \
    jlog_logger_debug(self.logger, message)

#define jlog_debug_join(...) \
    jlog_logger_debug_join(self.logger, __VA_ARGS__)

#define jlog_debug_fmt(fmt, ...) \
    jlog_logger_debug_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_debug(message) \
    jlog_logger_debug([JLApplication instance].logger, message)

#define jlog_global_debug_join(...) \
    jlog_logger_debug_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_debug_fmt(fmt, ...) \
    jlog_logger_debug_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Info
#define jlog_logger_info(logger, message) \
    [logger info:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_info_join(logger, ...) \
    jlog_logger_info(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_info_fmt(logger, fmt, ...) \
    jlog_logger_info(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_info(message) \
    jlog_logger_info(self.logger, message)

#define jlog_info_join(...) \
    jlog_logger_info_join(self.logger, __VA_ARGS__)

#define jlog_info_fmt(fmt, ...) \
    jlog_logger_info_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_info(message) \
    jlog_logger_info([JLApplication instance].logger, message)

#define jlog_global_info_join(...) \
    jlog_logger_info_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_info_fmt(fmt, ...) \
    jlog_logger_info_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Notice
#define jlog_logger_notice(logger, message) \
    [logger notice:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_notice_join(logger, ...) \
    jlog_logger_notice(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_notice_fmt(logger, fmt, ...) \
    jlog_logger_notice(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_notice(message) \
    jlog_logger_notice(self.logger, message)

#define jlog_notice_join(...) \
    jlog_logger_notice_join(self.logger, __VA_ARGS__)

#define jlog_notice_fmt(fmt, ...) \
    jlog_logger_notice_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_notice(message) \
    jlog_logger_notice([JLApplication instance].logger, message)

#define jlog_global_notice_join(...) \
    jlog_logger_notice_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_notice_fmt(fmt, ...) \
    jlog_logger_notice_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Warning
#define jlog_logger_warning(logger, message) \
    [logger warning:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_warning_join(logger, ...) \
    jlog_logger_warning(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_warning_fmt(logger, fmt, ...) \
    jlog_logger_warning(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_warning(message) \
    jlog_logger_warning(self.logger, message)

#define jlog_warning_join(...) \
    jlog_logger_warning_join(self.logger, __VA_ARGS__)

#define jlog_warning_fmt(fmt, ...) \
    jlog_logger_warning_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_warning(message) \
    jlog_logger_warning([JLApplication instance].logger, message)

#define jlog_global_warning_join(...) \
    jlog_logger_warning_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_warning_fmt(fmt, ...) \
    jlog_logger_warning_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Error
#define jlog_logger_error(logger, message) \
    [logger error:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_error_join(logger, ...) \
    jlog_logger_error(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_error_fmt(logger, fmt, ...) \
    jlog_logger_error(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_error(message) \
    jlog_logger_error(self.logger, message)

#define jlog_error_join(...) \
    jlog_logger_error_join(self.logger, __VA_ARGS__)

#define jlog_error_fmt(fmt, ...) \
    jlog_logger_error_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_error(message) \
    jlog_logger_error([JLApplication instance].logger, message)

#define jlog_global_error_join(...) \
    jlog_logger_error_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_error_fmt(fmt, ...) \
    jlog_logger_error_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)

// Critical
#define jlog_logger_critical(logger, message) \
    [logger critical:message file:@(__FILE__).lastPathComponent function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

#define jlog_logger_critical_join(logger, ...) \
    jlog_logger_critical(logger, jlog_join(__VA_ARGS__))

#define jlog_logger_critical_fmt(logger, fmt, ...) \
    jlog_logger_critical(logger, jlog_fmt(fmt, __VA_ARGS__))

#define jlog_critical(message) \
    jlog_logger_critical(self.logger, message)

#define jlog_critical_join(...) \
    jlog_logger_critical_join(self.logger, __VA_ARGS__)

#define jlog_critical_fmt(fmt, ...) \
    jlog_logger_critical_fmt(self.logger, fmt, __VA_ARGS__)

// global
#define jlog_global_critical(message) \
    jlog_logger_critical([JLApplication instance].logger, message)

#define jlog_global_critical_join(...) \
    jlog_logger_critical_join([JLApplication instance].logger, __VA_ARGS__)

#define jlog_global_critical_fmt(fmt, ...) \
    jlog_logger_critical_fmt([JLApplication instance].logger, fmt, __VA_ARGS__)
