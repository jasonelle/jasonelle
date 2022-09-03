//
//  JLLoggingSystem.h
//  JLKernel
//
//  Created by clsource on 02-02-22
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

NS_ASSUME_NONNULL_BEGIN

@interface JLLoggingSystem : NSObject

@property (nonatomic, strong, nullable) id<JLLoggerProtocol> factory;
@property (nonatomic) BOOL initialized;
@property (class) JLLoggingSystem * instance;
@property (class) id<JLLoggerProtocol> logger;

+ (instancetype) boot:(id<JLLoggerProtocol>) factory;

/// Internal testing aid that allows multiple bootstrapping
+ (instancetype) _boot:(id<JLLoggerProtocol>) factory;

@end

NS_ASSUME_NONNULL_END
