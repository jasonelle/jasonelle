//
//  JLJSBridgeHTTP.m
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

#import "JLJSBridgeHTTP.h"
#import <JLKernel/JLJSParams.h>

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_http";

@implementation JLJSBridgeHTTP

// TODO: implement
- (void)install {
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Bridge: %@", BRIDGE_NAME]];

    context.context[BRIDGE_NAME] = ^(NSDictionary *argv) {
        // JLJSParams * params = [[JLJSParams alloc] initWithDictionary:argv];

        // TODO: add http wrapper to native calls
        // Maybe this is better in an extension
    };

    [context.logger trace:@"JS HTTP Bridge Ready" function:@(__FUNCTION__) line:@(__LINE__)];
}

@end
