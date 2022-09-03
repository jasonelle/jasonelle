//
//  JLApplicationExtensions.h
//  JLKernel
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

- (void) install: (Class) extclass;

@end

NS_ASSUME_NONNULL_END
