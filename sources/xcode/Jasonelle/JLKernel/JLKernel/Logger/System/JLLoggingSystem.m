//
//  JLLoggingSystem.m
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

#import "JLLoggingSystem.h"

@implementation JLLoggingSystem

static JLLoggingSystem *_instance;
static id<JLLoggerProtocol> _logger;

+ (instancetype)instance {
    return _instance;
}

+ (void)setInstance:(JLLoggingSystem *)instance {
    _instance = instance;
}

+ (id<JLLoggerProtocol>)logger {
    if (!_logger) {
        _logger = [self instance].factory;
    }

    return _logger;
}

+ (void)setLogger:(id<JLLoggerProtocol>)logger {
    _logger = [self instance].factory;
}

+ (instancetype)initWithFactory:(id<JLLoggerProtocol>)factory {
    JLLoggingSystem *logger = [JLLoggingSystem new];

    logger.factory = factory;
    logger.initialized = YES;
    return logger;
}

+ (instancetype)boot:(id<JLLoggerProtocol>)factory {
    JLLoggingSystem *logger = [JLLoggingSystem initWithFactory:factory];

    if (JLLoggingSystem.instance && JLLoggingSystem.instance.initialized) {
        [NSException
         raise:@"JLLogging System already initialized"
         format:@""];
    }

    [JLLoggingSystem setInstance:logger];

    return logger;
}

/// Internal testing aid that allows multiple bootstrapping
+ (instancetype)_boot:(id<JLLoggerProtocol>)factory {
    JLLoggingSystem *logger = [JLLoggingSystem initWithFactory:factory];

    return logger;
}

@end
