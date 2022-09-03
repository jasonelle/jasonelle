//
//  JLJSConfig.h
//  JLKernel
//
//  Created by clsource on 15-04-22
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
#import <JLKernel/JLJSParams.h>
#import <JLKernel/JLJSContext.h>
#import <JLKernel/JLJSValue.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLJSConfig : NSObject

@property (nonatomic, strong, nonnull) NSDictionary * dict;
@property (nonatomic, strong, nonnull) JLJSParams * params;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) JLJSContext * context;
@property (nonatomic, strong, nonnull) JLJSValue * value;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary
                            context: (JLJSContext *) context
                              andValue: (JLJSValue *) value;

@end

NS_ASSUME_NONNULL_END
