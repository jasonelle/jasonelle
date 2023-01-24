//
//  JLJSMessageHandlers.m
//  JLKernel
//
//  Created by clsource on 15-05-22
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
    JLJSMessageHandlerOptions *options = [[JLJSMessageHandlerOptions alloc] initWithValue: command[@"options"]];
    
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
