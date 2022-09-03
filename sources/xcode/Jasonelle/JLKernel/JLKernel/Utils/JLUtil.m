//
//  JLUtil.m
//  JLKernel
//
//  Created by clsource on 05-05-22
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

#import "JLUtil.h"

@implementation JLUtil

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];

    if (self) {
        self.logger = logger;
    }

    return self;
}

@end
