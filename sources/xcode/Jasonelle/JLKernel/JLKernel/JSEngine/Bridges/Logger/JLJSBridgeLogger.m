//
//  JLJSBridgeLogger.m
//  JLKernel
//
//  Created by clsource on 14-04-22
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

#import "JLJSBridgeLogger.h"
#import <JLKernel/JLLogLevelFactory.h>
#import <JLKernel/JLJSParams.h>

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_logger";

@implementation JLJSBridgeLogger

- (void)install {
    // It's important to not use self or weakSelf
    // inside the context's binding
    // because the weakself it will be erased
    // since the install method is not retained
    // after use inside AppDelegate
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Bridge: %@", BRIDGE_NAME]];

    context.context[BRIDGE_NAME] = ^(NSDictionary *argv) {
        JLJSParams *params = [[JLJSParams alloc] initWithDictionary:argv];

        NSDictionary *metadata = [params dictionary:@"meta"];

        NSNumber *line = [params number:@"line"];

        NSString *file = [params string:@"file"];
        NSString *func = [params string:@"func"];

        NSString *source = [params string:@"source"];
        NSString *message = [params string:@"message"];
        NSString *levelString = [params string:@"level"];

        if (!message) {
            return;
        }

        JLLogLevel *level = [JLLogLevelFactory for:levelString];

        [logger log:level message:message metadata:metadata source:source file:file function:func line:line];
    };

    // Test the logger
    [context eval:
     [NSString stringWithFormat:@"%@({"                              \
      @"message: 'JS Logger Bridge ready'" \
      @", func: '%@'"                      \
      @", line: %@"                        \
      @"})", BRIDGE_NAME, @(__FUNCTION__), @(__LINE__)]
    ];
}

@end
