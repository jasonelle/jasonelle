//
//  JLAppDelegate.h
//  Jasonelle
//
//  Created by clsource on 01-02-22
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

#import <UIKit/UIKit.h>
#import <JLKernel/JLKernel.h>

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(JLAppDelegate)
@interface JLAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) id<JLLoggerProtocol> logger;
@property (nonatomic, strong) JLApplication * app;

#pragma mark - Lifecycle
- (BOOL) application:(UIApplication *)application
    didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end

NS_ASSUME_NONNULL_END
