//
//  JLEventAppDidEnterBackground.m
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

#import "JLEventAppDidEnterBackground.h"
#import <UIKit/UIKit.h>

@implementation JLEventAppDidEnterBackground

- (void)install {
    [super install];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(onEvent:)
            name:UIApplicationDidEnterBackgroundNotification
          object:nil];
}

- (void)uninstall {
    [super uninstall];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)notification {
    NSDictionary *params = @{};

    jlog_trace(@"App Did Enter Background");

    [self triggerWithParams:params];
}

@end
