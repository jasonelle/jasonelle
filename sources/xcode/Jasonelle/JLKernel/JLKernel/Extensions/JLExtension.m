//
//  JLExtension.m
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

#import "JLExtension.h"
#import "JLApplication.h"

static NSString *NAMESPACE = @"com.jasonelle.app.extensions";

@implementation JLExtension

@synthesize app;
@synthesize logger;
@synthesize name = _name;
@synthesize handlers = _handlers;
@synthesize webview = _webview;

- (NSDictionary *)handlers {
    if (!_handlers) {
        _handlers = @{};
    }
    return _handlers;
}

- (NSString *)name {
    if (!_name) {
        _name = [[self class] name];
    }

    return _name;
}

#pragma mark - Extension Events
- (void)install {
    // Override in child and call super
    jlog_trace_join(@"Installing: ", self.name);
}

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    jlog_trace_join(@"Installing WebView Bridge: ", self.name);
    self.webview = webView;
    return webView;
}

#pragma mark - Instance Methods
- (instancetype)initWithName:(NSString *)name
                      logger:(nonnull id<JLLoggerProtocol>)logger
                      andApp:(nonnull JLApplication *)app {
    self = [super init];

    if (self) {
        self.name = name;
        self.logger = logger;
        self.app = app;
    }

    return self;
}

- (NSDictionary *)installHandlers:(NSDictionary *)handlers {
    // Can Override in Child if you implement WebView Handlers
    NSMutableDictionary *newHandlers = [handlers mutableCopy];

    for (NSString *key in self.handlers.allKeys) {
        [newHandlers setObject:self.handlers[key] forKey:key];
    }

    return [newHandlers copy];
}

- (WKWebView *) injectJS {
    // Install the wrappers inside the webview
    self.webview = [self.app.utils.webview inject:self intoWebView:self.webview];
    return self.webview;
}

#pragma mark - App Delegate Methods

/// Overwrite in Children if Needed
/// Access renderer with app.renderer
- (void)appDidAppear {}
- (void)appDidDisappear {}
- (void)appDidLoad {}

- (void)application:(nonnull UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {}


- (BOOL)application:(nonnull UIApplication *)application didFinishLaunchingWithOptions:(nonnull NSDictionary *)launchOptions {
    return YES;
}


- (void)application:(nonnull UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {}


- (void)application:(nonnull UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {}


- (BOOL)application:(nonnull UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}

#pragma mark - Class methods

+ (instancetype)instanceWithLogger:(id<JLLoggerProtocol>)logger
                            andApp:(JLApplication *)app {
    return [[[self class] alloc] initWithName:[self name] logger:logger andApp:app];
}


+ (NSString *)namespaceForClass:(Class)class {
    return [NSString stringWithFormat:@"%@.%@", NAMESPACE, NSStringFromClass(class)];
}

+ (NSString *)name {
    return [self namespaceForClass:[self class]];
}

@end
