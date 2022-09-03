//
//  JLEventOrientationDidChange.m
//  JLKernel
//
//  Created by clsource on 22-04-22
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

#import "JLEventOrientationDidChange.h"
#import <UIKit/UIKit.h>

@implementation JLEventOrientationDidChange

- (void)startMonitoring {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)stopMonitoring {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)install {
    [super install];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(onEvent:)
            name:UIDeviceOrientationDidChangeNotification
          object:nil];
}

- (void)uninstall {
    [super uninstall];
    [self stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)notification {
    jlog_trace(@"App Did Change Orientation");

    // Just a little delay, since on boot it triggers a lot
    [self triggerAfterMilliseconds:0.5 withParams:self.env.process.device];
}

@end
