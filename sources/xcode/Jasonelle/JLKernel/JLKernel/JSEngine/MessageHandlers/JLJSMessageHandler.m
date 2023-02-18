//
//  JLJSMessageHandler.m
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

- (instancetype) initWithApplication:(JLApplication *)app andExtension:(JLExtension *)extension {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
        self.extension = extension;
    }

    return self;
}

+ (nonnull NSString *)key {
    return NSStringFromClass(self.class);
}

- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
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

- (void) rejectEmpty {
    self.reject(@"");
}

- (void) resolveEmpty {
    self.resolve(@{});
}

- (void) resolveTrue {
    self.resolve(@YES);
}

- (void) resolveFalse {
    self.resolve(@NO);
}

@end
