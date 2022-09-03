//
//  JLJSMessageHandlers.h
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
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLWebViewMessageHandlerProtocol.h>

@import WebKit;

@class JLApplication;

NS_ASSUME_NONNULL_BEGIN

@interface JLJSMessageHandlers : NSObject <JLWebViewMessageHandlerProtocol>
@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) NSDictionary * handlers;

- (instancetype) initWithApplication: (JLApplication *) app
                           andLogger: (id<JLLoggerProtocol>) logger;

@end

NS_ASSUME_NONNULL_END
