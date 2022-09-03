//
//  JLJSConfigLoader.h
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
#import <JLKernel/JLJSContext.h>
#import <JLKernel/JLJSConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLJSConfigLoader : NSObject

@property (nonatomic, strong, nonnull) JLJSContext * context;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

- (instancetype) initWithContext: (JLJSContext *) context;

- (nonnull JLJSValue *) value;
- (nonnull JLJSConfig *) load;

@end

NS_ASSUME_NONNULL_END
