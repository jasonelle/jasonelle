//
//  JLJSBridge.m
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

#import "JLJSBridge.h"

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_<name>";

@implementation JLJSBridge

- (instancetype)initWithContext:(JLJSContext *)context {
    self = [super init];

    if (self) {
        self.context = context;
        self.logger = context.logger;
    }

    return self;
}

- (void)install {
    [self.context.logger warning:@"Bridge must implement install method"];
}

+ (id<JLJSBridgeProtocol>)installInContext:(nonnull JLJSContext *)context {
    id<JLJSBridgeProtocol> bridge = [[[self class] alloc] initWithContext:context];

    [bridge install];
    return bridge;
}

@end
