//
//  JLEventAppWillEnterForeground.m
//  JLKernel
//
//  Created by clsource on 25-04-22
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

#import "JLEventAppWillEnterForeground.h"
#import <UIKit/UIKit.h>

@implementation JLEventAppWillEnterForeground

- (void)install {
    [super install];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(onEvent:)
            name:UIApplicationWillEnterForegroundNotification
          object:nil];
}

- (void)uninstall {
    [super uninstall];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)notification {
    // Send the current badge number
    // and tell if it needs to be cleaned up
    NSDictionary *params = @{
        @"badge": @([UIApplication sharedApplication].applicationIconBadgeNumber),
        @"is_dirty": @([UIApplication sharedApplication].applicationIconBadgeNumber != 0)
    };

    jlog_trace(@"App Will Enter Foreground");

    [self triggerWithParams:params];
}

@end
