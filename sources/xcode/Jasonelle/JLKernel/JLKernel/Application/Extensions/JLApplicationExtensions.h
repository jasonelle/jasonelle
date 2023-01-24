//
//  JLApplicationExtensions.h
//  JLKernel
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


#import <Foundation/Foundation.h>
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLExtension.h>
#import <JLKernel/JLWebViewMessageHandlerProtocol.h>

@import UIKit;
@import WebKit;

@class JLApplication;

NS_ASSUME_NONNULL_BEGIN

@protocol JLApplicationExtensionsProtocol <NSObject, JLWebViewMessageHandlerProtocol>

/// Lifecycle
- (BOOL)application: (UIApplication *) application
didFinishLaunchingWithOptions:(NSDictionary *) launchOptions;

// OpenURL
- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

// Push Notifications Events
- (void) application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken;

// TODO: Deprecated. See updated method in apple docs
- (void) application: (UIApplication *) application
didReceiveRemoteNotification:(NSDictionary *) userInfo;

- (void) application: (UIApplication *) application
didFailToRegisterForRemoteNotificationsWithError: (NSError *) error;

// Called within the renderer
- (void) appDidLoad;
- (void) appDidAppear;
- (void) appDidDisappear;

// MARK: - WebView
- (WKWebView *) appDidLoadWithWebView: (WKWebView *) webView;

@end

@interface JLApplicationExtensions : NSObject

@property (nonatomic, strong, nonnull) NSDictionary * registry;

@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) id<JLApplicationExtensionsProtocol> extensions;

- (instancetype) initWithApplication: (JLApplication *) app andLogger:(id<JLLoggerProtocol>) logger;

- (NSArray<JLExtension *> *) add: (JLExtension *) ext;
- (nullable JLExtension *) get: (Class) extclass;
- (nullable NSArray<JLExtension *> *) all;

- (void) install: (Class) extclass;

@end

NS_ASSUME_NONNULL_END
