//
//  JLApplicationBadgeIncrementMessageHandler.m
//  JLApplicationBadge
//
//  Created by clsource on 01-09-22
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


#import "JLApplicationBadgeIncrementMessageHandler.h"
#import "JLApplicationBadge.h"

@implementation JLApplicationBadgeIncrementMessageHandler

- (void)handleWithOptions:(nonnull NSDictionary *)options {
    NSNumber * number = (NSNumber*)options;
    [self.badge set:number];
    self.resolve(number);
}

@end
