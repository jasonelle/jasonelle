//
//  JLExtensions.m
//  JLExtensions
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


#import <JLExtensions/JLExtensions.h>

@implementation JLExtensions

- (instancetype) initWithApp: (JLApplication *) app {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
    }
    return self;
}

// List of available extensions classes
// Add Using add method in AppDelegate
- (NSDictionary *) classes {
    if (!_classes) {
        _classes = @{};
    }
    return _classes;
}

- (NSDictionary *) handlers {
    if (!_handlers) {
        // Native Handlers Available for Usage Within WebView
        // Add the handlers as an empty object
        // later we would need it to handle
        // Example:
        //        [handlers
        //         setObject:[[JLJSLoggerMessageHandler alloc]
        //                    initWithApplication:self.app]
        //         forKey:JLJSLoggerMessageHandler.key];
        
        _handlers = @{};
    }
    return _handlers;
}

#pragma mark - Install Methods

- (BOOL) install: (Class) cls {
    jlog_trace_join(@"Installing Extension ", NSStringFromClass(cls));
    [self.app.ext install:cls];
    id<JLExtensionProtocol> ext = [self.app.ext get:cls];
    self.handlers = [ext installHandlers:self.handlers];
    return YES;
}

// Add Extensions as Class
- (void) add: (Class) cls {
    NSMutableDictionary * classes = [self.classes mutableCopy];
    [classes setObject:cls forKey:NSStringFromClass(cls)];
    self.classes = [classes copy];
}

- (BOOL) install {
    
    JLApplication * app = self.app;
    
    jlog_logger_trace(app.logger, @"Installing Extensions");
    
    // Begin Installing Extensions
    for (Class cls in self.classes.allValues) {
        [self install:cls];
    }
    
    // Ensure we can have a pointer to the extensions object
    // inside the app. So we can find the extensions more easily
    // later.
    app.ext.extensions = self;
    
    return YES;
}

#pragma mark - Lifecycle

- (BOOL)application: (UIApplication *) application
didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    BOOL result = YES;
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        result = [ext application: application didFinishLaunchingWithOptions: launchOptions];
    }
    return result;
}

// OpenURL
- (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
             options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL result = YES;
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        result = [ext application: application openURL: url options: options];
    }
    return result;
}

// Push Notifications Events
- (void) application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken {
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext application: application didRegisterForRemoteNotificationsWithDeviceToken: deviceToken];
    }
}

- (void) application: (UIApplication *) application
didReceiveRemoteNotification:(NSDictionary *) userInfo {
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext application: application didReceiveRemoteNotification:userInfo];
    }
}

- (void) application: (UIApplication *) application
didFailToRegisterForRemoteNotificationsWithError: (NSError *) error {
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext application: application didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

- (void) appDidLoad {
    jlog_trace(@"App Did Load");
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext appDidLoad];
    }
}

- (void) appDidAppear {
    jlog_trace(@"App Did Appear");
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext appDidAppear];
    }
}

- (void) appDidDisappear {
    jlog_trace(@"App Did Disappear");
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        [ext appDidDisappear];
    }
}

// Enable extensions to install JS bridges in webView
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    // Can override the config for the WebView
    jlog_trace(@"App Did Load With WebView");
    for (id<JLExtensionProtocol> ext in self.app.ext.all) {
        webView = [ext appDidLoadWithWebView:webView];
    }
    return webView;
}

#pragma mark - Handling WebView Messages

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message replyHandler:(nonnull void (^)(id _Nullable, NSString * _Nullable))replyHandler {
    jlog_trace(@"WebView Message Received in Extensions");
    
    // Check if is a dictionary
    NSDictionary * body = @{@"data": @{}};
    
    if ([message.body respondsToSelector:@selector(objectForKey:)]) {
        body = (NSDictionary *) message.body;
    }
    
    NSDictionary * command = (body[@"com.jasonelle.agent.trigger"] ? body[@"com.jasonelle.agent.trigger"] : @{});
    
    NSString * name = command[@"name"];
    JLJSMessageHandlerOptions * options = [[JLJSMessageHandlerOptions alloc] initWithValue: command[@"options"]];
    
    id<JLJSMessageHandlerProtocol> handler = self.handlers[name];
    if (handler) {
        
        handler.message = message;
        handler.controller = userContentController;
        handler.webView = message.webView;
        handler.body = body;
        
        [handler setReplyHandler:replyHandler];
        
        return [handler handleWithOptions:options];
    }
    
    // Native Handler Not Found
    // Look if this is a call for a WebView action
    command = (body[@"com.jasonelle.agent.action"] ? body[@"com.jasonelle.agent.action"] : @{});
    
    name = command[@"name"];
    options = [[JLJSMessageHandlerOptions alloc] initWithValue: command[@"options"]];
    
    // Find the action in the App.js context
//    params = Params(app: app, params: app.routes.load().params.get("/").get("component"))
//
//    actions = params.actions(context: context)
//
    jlog_trace(@"Checking for Actions in app.js");
    // TODO: Maybe implement actions for the current route instead of /
    JLJSParams * actions = [[[[self.app.routes load].params get:@"/"] get:@"component"] get:@"actions"];
    
    JLJSParams * action = [actions get:name];
    if (action.value.canCall) {
        
        jlog_trace_join(@"Calling Function ", name);
        
        JLJSValue * result = [action.value secureCallWithArguments:@[options.value]];
        
        // TODO: Figure out how to handle returning promises
        //if (result.exists) {
            return replyHandler(result.value.toObject, nil);
        //}
        
        //return replyHandler(nil, @"Failed to call value");
    }
    
    jlog_warning(@"Unknown Handler");
    
    // Always use the reply handler
    // otherwise the JS execution would be
    // waiting for a response indefinetly
    replyHandler(nil, @"Unknown handler");
}

@end
