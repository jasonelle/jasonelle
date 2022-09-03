//
//  JLJSMessageHandler.h
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


#import <Foundation/Foundation.h>
#import <JLKernel/JLKernel.h>

@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@protocol JLJSMessageHandlerProtocol <NSObject>

@property (nonnull, nonatomic, strong) WKUserContentController * controller;
@property (nonnull, nonatomic, strong) WKScriptMessage * message;
@property (nonnull, nonatomic, strong) WKWebView * webView;
@property (nonnull, nonatomic, strong) NSDictionary * body;

+ (NSString *) key;

- (instancetype) initWithApplication: (JLApplication *) app;

- (void) setReplyHandler:(void (^)(id _Nullable reply, NSString *_Nullable errorMessage))replyHandler;

- (void) handleWithOptions: (NSDictionary *) options;

@end

@interface JLJSMessageHandler : NSObject<JLJSMessageHandlerProtocol>

@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, copy, nonnull) void (^resolve)(id);
@property (nonatomic, copy, nonnull) void (^reject)(NSString *);

@end

NS_ASSUME_NONNULL_END
