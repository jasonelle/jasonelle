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
#import "JLOneSignalLoginHandler.h"
#import "JLOneSignalLogoutHandler.h"
#import "JLOneSignalNotificationsOptOutHandler.h"
#import "JLOneSignalPromptHandler.h"
#import "JLOneSignalSMSSetHandler.h"
#import "JLOneSignalSMSRemoveHandler.h"
#import "JLOneSignalEmailSetHandler.h"
#import "JLOneSignalEmailRemoveHandler.h"
#import "JLOneSignalTagsGetHandler.h"
#import "JLOneSignalTagsAddHandler.h"
#import "JLOneSignalTagsRemoveHandler.h"

#import "JLOneSignalConfig.h"

NSString * const kJLOneSignalPushSubscriptionDidChangeEvent = @"window.$onesignal.events.notifications.subscription.changed.dispatch";

@implementation JLOneSignal

- (void) install {
    [super install];
    
    JLOneSignalGetInfoHandler * infoHandler = [[JLOneSignalGetInfoHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalLoginHandler * loginHandler = [[JLOneSignalLoginHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalLogoutHandler * logoutHandler = [[JLOneSignalLogoutHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalNotificationsOptOutHandler * optOutHandler = [[JLOneSignalNotificationsOptOutHandler alloc] initWithApplication:self.app andExtension:self];
    
    // Shows the prompt to allow user notifications
    JLOneSignalPromptHandler * promptHandler = [[JLOneSignalPromptHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalEmailSetHandler * emailAddHandler = [[JLOneSignalEmailSetHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalEmailRemoveHandler * emailRemoveHandler = [[JLOneSignalEmailRemoveHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalSMSSetHandler * smsAddHandler = [[JLOneSignalSMSSetHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalSMSRemoveHandler * smsRemoveHandler = [[JLOneSignalSMSRemoveHandler alloc] initWithApplication:self.app andExtension:self];

    
    // https://documentation.onesignal.com/docs/device-user-model-mobile-sdk-mapping#tags
    
    JLOneSignalTagsGetHandler * tagsGetHandler = [[JLOneSignalTagsGetHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalTagsAddHandler * tagsAddHandler = [[JLOneSignalTagsAddHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLOneSignalTagsRemoveHandler * tagsRemoveHandler = [[JLOneSignalTagsRemoveHandler alloc] initWithApplication:self.app andExtension:self];
    
    // TODO: add optOut, optIn, optedIn handlers https://documentation.onesignal.com/docs/mobile-sdk-reference#optout-%2C-optin-%2C-optedin
    // TODO: add setLanguage https://documentation.onesignal.com/docs/mobile-sdk-reference#setlanguage
    
    self.handlers = @{
        @"$onesignal.info" : infoHandler,
        @"$onesignal.login" : loginHandler,
        @"$onesignal.logout" : logoutHandler,
        @"$onesignal.disable" : optOutHandler,
        @"$onesignal.prompt" : promptHandler,
        @"$onesignal.email.add" : emailAddHandler,
        @"$onesignal.email.remove" : emailRemoveHandler,
        @"$onesignal.sms.add" : smsAddHandler,
        @"$onesignal.sms.remove" : smsRemoveHandler,
        @"$onesignal.tags.get" : tagsGetHandler,
        @"$onesignal.tags.add" : tagsAddHandler,
        @"$onesignal.tags.remove" : tagsRemoveHandler,
    };
}

- (void) setupOneSignalDebug {
    // Remove this method to stop OneSignal Debugging
    // LogLevel: ONE_S_LL_NONE | ONE_S_LL_FATAL | ONE_S_LL_ERROR | ONE_S_LL_WARN | ONE_S_LL_INFO | ONE_S_LL_DEBUG | ONE_S_LL_VERBOSE
    
    [OneSignal.Debug setLogLevel:ONE_S_LL_VERBOSE];
    
    // Sets the logging level to show as alert dialogs in your app. Make sure to remove this before submitting to the app store.
    // [OneSignal.Debug setAlertLevel:ONE_S_LL_NONE];
}

- (BOOL)application: (UIApplication *) application
didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    
    [OneSignal.Debug setLogLevel:ONE_S_LL_FATAL];
    if(self.app.env.type == JLEnvironmentTypeDevelop) {
        [self setupOneSignalDebug];
    }
    
    [OneSignal initialize:kJLOneSignalAppID withLaunchOptions:launchOptions];
    
    // Get notifications about push subscription status
    [OneSignal.User.pushSubscription addObserver:self];
    [OneSignal.Notifications addPermissionObserver:self];
    
    // https://documentation.onesignal.com/docs/prompt-for-push-permissions
    // https://documentation.onesignal.com/docs/mobile-sdk-reference#requestpermission-fallbacktosettings-push
    
    // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
    // Passing true will fallback to setting prompt if the user denies push permissions
    //    [OneSignal.Notifications requestPermission:^(BOOL accepted) {
    //        jlog_trace_fmt(@"User accepted notifications: %d", accepted);
    //    } fallbackToSettings:true];
    
    return YES;
    
}

#pragma mark - Push Subscription Change
// https://documentation.onesignal.com/docs/mobile-sdk-reference#addobserver-push-subscription-changes
- (void)onPushSubscriptionDidChangeWithState:(OSPushSubscriptionChangedState *)state {
    
    if(!self.webview) {
        return;
    }
    
    jlog_join(@"Push Subscription Did Change With State: ", state);
    
   // send event to js
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.app.utils.webview
         dispatch:kJLOneSignalPushSubscriptionDidChangeEvent
         arguments:@{
            @"origin": @"OneSignal.User.pushSubscription",
            @"state": state
        }
         inWebView:self.webview];
    });
}

- (void)onNotificationPermissionDidChange:(BOOL)granted {
    
    jlog_join(@"Notification Permission changed: ", jlog_b2s(granted));
    
    if(!self.webview) {
        return;
    }
    
    // send event to js
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.app.utils.webview
         dispatch:kJLOneSignalPushSubscriptionDidChangeEvent
         arguments:@{
            @"origin": @"OneSignal.Notifications",
            @"state": @(granted)
        }
         inWebView:self.webview];
    });
}

- (void) cleanup {
    [OneSignal.User.pushSubscription removeObserver:self];
    [OneSignal.Notifications removePermissionObserver: self];
}

#pragma mark - Extension Public Methods

#pragma mark - WebView Injection
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    return [self injectJS];
}

@end
