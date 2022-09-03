//
//  JLApplicationBadge.m
//  JLApplicationBadge
//
//  Created by clsource on 06-05-22
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


#import <JLApplicationBadge/JLApplicationBadge.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import "JLApplicationBadgeClearMessageHandler.h"
#import "JLApplicationBadgeIncrementMessageHandler.h"

@implementation JLApplicationBadge

- (void) install {
    [super install];
    [self authorize];
    
    // Setup Handlers for WebView
    JLApplicationBadgeClearMessageHandler * clearHandler = [[JLApplicationBadgeClearMessageHandler alloc] initWithApplication:self.app];
    
    clearHandler.badge = self;
    
    JLApplicationBadgeIncrementMessageHandler * incHandler = [[JLApplicationBadgeIncrementMessageHandler alloc] initWithApplication:self.app];
    
    incHandler.badge = self;
    
    self.handlers = @{
        @"$badge.set": incHandler,
        @"$badge.clear": clearHandler
    };
}

- (NSNumber *)number {
    if (!_number) {
        _number = @([UIApplication sharedApplication].applicationIconBadgeNumber);
    }

    return _number;
}

- (void)authorize {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self.granted = granted;
        jlog_trace_join(@"User Application Badge Notification Authorization: ", (granted ? @"granted" : @"not granted"));

        if (error) {
            jlog_warning_join(@"Error Registering for User Notifications ", error.description);
        }
    }];
}

- (int)current {
    self.number = @([UIApplication sharedApplication].applicationIconBadgeNumber);
    return self.number.intValue;
}

- (void)clear {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.number = @0;
    jlog_trace(@"App Icon Badge Number Cleared");
}

- (int) set: (NSNumber *) number {
    [UIApplication sharedApplication].applicationIconBadgeNumber = number.intValue;
    self.number = number;
    jlog_trace_join(@"App Icon Badge Number set to: ", number);
    return number.intValue;
}

@end
