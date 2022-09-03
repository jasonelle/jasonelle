//
//  JLJSBridge.h
//  JLKernel
//
//  Created by clsource on 14-04-22
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
#import <JLKernel/JLJSContext.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLJSBridgeProtocol <NSObject>

- (void) install;
+ (id<JLJSBridgeProtocol>) installInContext: (JLJSContext *) context;

@end

@interface JLJSBridge : NSObject<JLJSBridgeProtocol>

@property (nonatomic, strong, nonnull) JLJSContext * context;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

- (instancetype) initWithContext: (JLJSContext *) context;

@end

NS_ASSUME_NONNULL_END
