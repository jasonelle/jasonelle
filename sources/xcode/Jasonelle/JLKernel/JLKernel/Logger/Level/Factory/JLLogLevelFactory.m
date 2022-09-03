//
//  JLLogLevelFactory.m
//  JLKernel
//
//  Created by clsource on 02-02-22
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

#import "JLLogLevelFactory.h"

@implementation JLLogLevelFactory

static JLLogLevel *_trace;
static JLLogLevel *_debug;
static JLLogLevel *_info;
static JLLogLevel *_notice;
static JLLogLevel *_warning;
static JLLogLevel *_error;
static JLLogLevel *_critical;
static JLLogLevel *_disabled;

+ (JLLogLevel *)trace {
    if (!_trace) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelTrace;
        level.severity = JLLogSeverityTrace;
        _trace = level;
    }

    return _trace;
}

+ (JLLogLevel *)debug {
    if (!_debug) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelDebug;
        level.severity = JLLogSeverityDebug;
        _debug = level;
    }

    return _debug;
}

+ (JLLogLevel *)info {
    if (!_info) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelInfo;
        level.severity = JLLogSeverityInfo;
        _info = level;
    }

    return _info;
}

+ (JLLogLevel *)notice {
    if (!_notice) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelNotice;
        level.severity = JLLogSeverityNotice;
        _notice = level;
    }

    return _notice;
}

+ (JLLogLevel *)warning {
    if (!_warning) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelWarning;
        level.severity = JLLogSeverityWarning;
        _warning = level;
    }

    return _warning;
}

+ (JLLogLevel *)error {
    if (!_error) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelError;
        level.severity = JLLogSeverityError;
        _error = level;
    }

    return _error;
}

+ (JLLogLevel *)critical {
    if (!_critical) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelCritical;
        level.severity = JLLogSeverityCritical;
        _critical = level;
    }

    return _critical;
}

+ (JLLogLevel *)disabled {
    if (!_disabled) {
        JLLogLevel *level = [JLLogLevel new];
        level.label = JLLogLabelDisabled;
        level.severity = JLLogSeverityDisabled;
        _disabled = level;
    }

    return _disabled;
}

+ (NSDictionary *)all {
    static NSDictionary *levels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        levels = @{
            @"trace": [self trace],
            @"debug": [self debug],
            @"info": [self info],
            @"notice": [self notice],
            @"warning": [self warning],
            @"error": [self error],
            @"critical": [self critical],
            @"disabled": [self disabled]
        };
    });

    return levels;
}

+ (JLLogLevel *)for:(NSString *)identifier {
    JLLogLevel *level = self.all[identifier];
    return (level ? level : [self disabled]);
}
@end
