//
//  AppDelegate.m
//  App
//
//  Created by clsource on 13-04-22
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
   self.extensions = [[AppExtensions alloc] initWithApp:self.app];
    
    return ready && [self.extensions application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [super application:app openURL:url options:options];
}

// TODO: Create Push Extension
// Uncomment if Push Notifications will be used

#pragma mark - Push Notifications Events

//- (void) application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken {
//    [self.extensions.extensions application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//}


// Deprecated. TODO: See if can be updated
//- (void) application: (UIApplication *) application
//didReceiveRemoteNotification:(NSDictionary *) userInfo {
//    [self.extensions.extensions application:application didReceiveRemoteNotification:userInfo];
//}
//
//- (void) application: (UIApplication *) application
//didFailToRegisterForRemoteNotificationsWithError: (NSError *) error {
//    [self.extensions.extensions application:application didFailToRegisterForRemoteNotificationsWithError:error];
//}
@end
