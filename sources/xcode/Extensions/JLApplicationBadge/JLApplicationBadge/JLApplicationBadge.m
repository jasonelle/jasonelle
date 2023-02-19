//
//  JLApplicationBadge.m
//  JLApplicationBadge
//
//  Created by clsource on 06-05-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
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

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    
    return [self.app.utils.webview inject:self intoWebView:webView];
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
