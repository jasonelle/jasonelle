//
//  JLJSMessageHandler.m
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


#import "JLJSMessageHandler.h"

@implementation JLJSMessageHandler

@synthesize body;
@synthesize message;
@synthesize webView;
@synthesize controller;

- (instancetype)initWithApplication:(JLApplication *)app {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
    }

    return self;
}

+ (nonnull NSString *)key {
    return NSStringFromClass(self.class);
}

- (void)handleWithOptions:(nonnull NSDictionary *)options {
    jlog_trace_join(@"Handling ", self.class.key, @" with options: ", options.description);

    // Call reject or accept in child
}

- (void)setReplyHandler:(void (^)(id _Nullable reply, NSString *_Nullable errorMessage))replyHandler {
    // Sets the resolve and reject handlers
    void (^resolve)(id _Nullable) = ^void (id _Nullable result) {
        replyHandler(result, nil);
    };

    self.resolve = resolve;

    void (^reject)(NSString * _Nullable) = ^void (NSString * _Nullable errorMessage) {
        replyHandler(nil, errorMessage);
    };

    self.reject = reject;
}

@end
