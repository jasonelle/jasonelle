//
//  JLApplicationBadgeClearMessageHandler.m
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


#import "JLApplicationBadgeClearMessageHandler.h"
#import "JLApplicationBadge.h"

@implementation JLApplicationBadgeClearMessageHandler

- (void)handleWithOptions:(nonnull NSDictionary *)options {
    [self.badge clear];
    self.resolve(@YES);
}

@end
