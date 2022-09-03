//
//  JLJSPolyfill.m
//  JLKernel
//
//  Created by clsource on 21-04-22
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

#import "JLJSPolyfill.h"

@implementation JLJSPolyfill

- (instancetype)initWithContext:(JLJSContext *)context {
    self = [super init];

    if (self) {
        self.context = context;
    }

    return self;
}

- (void)install {
    [self.context.logger warning:@"Polyfill must implement install method"];
}

+ (id<JLJSPolyfillProtocol>)installInContext:(nonnull JLJSContext *)context {
    id<JLJSPolyfillProtocol> fill = [[[self class] alloc] initWithContext:context];

    [fill install];
    return fill;
}

@end
