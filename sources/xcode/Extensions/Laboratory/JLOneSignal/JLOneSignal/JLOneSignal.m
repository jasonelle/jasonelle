//
//  JLOneSignal.m
//  JLOneSignal
//
//  Created by clsource on 20-09-23.
//  Copyright (c) Jasonelle.com
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


#import "JLOneSignal.h"
#import "JLOneSignalGetInfoHandler.h"

#import <OneSignal/OneSignal.h>

NSString * const kJLOneSignalAppID = @"YOUR_ONESIGNAL_APP_ID";

@implementation JLOneSignal

- (void) install {
    [super install];
    
    JLOneSignalGetInfoHandler * handler = [[JLOneSignalGetInfoHandler alloc] initWithApplication:self.app andExtension:self];

    self.handlers = @{
        @"$onesignal.get" : handler
    };
}

- (BOOL)application: (UIApplication *) application
didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    
    // Remove this method to stop OneSignal Debugging
    // LogLevel: ONE_S_LL_NONE | ONE_S_LL_FATAL | ONE_S_LL_ERROR | ONE_S_LL_WARN | ONE_S_LL_INFO | ONE_S_LL_DEBUG | ONE_S_LL_VERBOSE
    [OneSignal setLogLevel:ONE_S_LL_VERBOSE visualLevel:ONE_S_LL_NONE];

    // OneSignal initialization
    [OneSignal initWithLaunchOptions:launchOptions];
    [OneSignal setAppId:kJLOneSignalAppID];

    
    // promptForPushNotifications will show the native iOS notification permission prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        jlog_trace_fmt(@"User accepted notifications: %d", accepted);
    }];

    // Set your customer userId
    // [OneSignal setExternalUserId:@"userId"];
    
    return YES;
    
}

#pragma mark - Extension Public Methods

#pragma mark - WebView Injection
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    return [self injectJS];
}

@end
