//
//  JLJSMessageHandlers.m
//  JLKernel
//
//  Created by clsource on 15-05-22
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


#import "JLJSMessageHandlers.h"
#import <JLKernel/JLJSMessageHandler.h>
#import <JLKernel/JLJSLoggerMessageHandler.h>

@implementation JLJSMessageHandlers

- (NSDictionary *)handlers {
    if (!_handlers) {
        NSMutableDictionary *handlers = [@{} mutableCopy];

        // Add the handlers as an empty object
        // later we would need it to handle
        [handlers
         setObject:[[JLJSLoggerMessageHandler alloc]
                    initWithApplication:self.app]
            forKey:JLJSLoggerMessageHandler.key];

        _handlers = [handlers copy];
    }
    return _handlers;
}

- (instancetype)initWithApplication:(JLApplication *)app andLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = logger;
    }
    return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message replyHandler:(nonnull void (^)(id _Nullable, NSString * _Nullable))replyHandler {
    jlog_trace(@"WebView Message Received in Kernel");

    // Check if is a dictionary
    NSDictionary *body = @{@"data": @{}};

    if ([message.body respondsToSelector:@selector(objectForKey:)]) {
        body = (NSDictionary *) message.body;
    }

    NSDictionary *command = (body[@"com.jasonelle.agent.kernel"] ? body[@"com.jasonelle.agent.kernel"] : @{});

    NSString *name = command[@"name"];
    NSDictionary *options = command[@"options"];
    NSDictionary *handlers = self.handlers;

    id<JLJSMessageHandlerProtocol> handler = handlers[name];

    if (handler) {

        handler.message = message;
        handler.controller = userContentController;
        handler.webView = message.webView;
        handler.body = body;

        [handler setReplyHandler:replyHandler];

        return [handler handleWithOptions:options];
    }

    jlog_warning(@"Unknown Kernel Handler");
    replyHandler(nil, @"Unknown Kernel Handler");
}

@end
