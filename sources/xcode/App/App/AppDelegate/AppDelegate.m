//
//  AppDelegate.m
//  App
//
//  Created by clsource on 13-04-22
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


#import "AppDelegate.h"

/// Use this file to configure your app's delegate
@implementation AppDelegate

- (BOOL) application:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    // Call the super's method to initialize the framework
    // with default settings
    // after that you can access the app to override or use the available properties with
    // self.app
    BOOL ready = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Add extensions
    JLExtensions * extensions = [[JLExtensions alloc] initWithApp:self.app];
    
    [extensions add:JLATTrackingManager.class];
    [extensions add:JLApplicationBadge.class];
    
    ready = [extensions install] && [extensions application:application didFinishLaunchingWithOptions:launchOptions];
    
    return ready;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [super application:app openURL:url options:options];
    return [self.app.ext.extensions application:app openURL:url options:options];
}

// TODO: Create Push Extension
// Uncomment if Push Notifications will be used
//#pragma mark - Push Notifications Events
//- (void) application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken {
//    [self.app.ext.extensions application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//}
//
// Deprecated. TODO: See if can be updated
//- (void) application: (UIApplication *) application
//didReceiveRemoteNotification:(NSDictionary *) userInfo {
//    [self.app.ext.extensions application:application didReceiveRemoteNotification:userInfo];
//}
//
//- (void) application: (UIApplication *) application
//didFailToRegisterForRemoteNotificationsWithError: (NSError *) error {
//    [self.app.ext.extensions application:application didFailToRegisterForRemoteNotificationsWithError:error];
//}
@end
