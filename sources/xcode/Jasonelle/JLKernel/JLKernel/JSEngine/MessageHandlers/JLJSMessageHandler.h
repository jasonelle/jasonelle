//
//  JLJSMessageHandler.h
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
