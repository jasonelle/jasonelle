//
//  AppDelegate.h
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


#import <Foundation/Foundation.h>
#import <Jasonelle/Jasonelle.h>

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(AppDelegate)
@interface AppDelegate : JLAppDelegate <UIApplicationDelegate>

#pragma mark - Lifecycle
- (BOOL) application:(UIApplication *)application
    didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
