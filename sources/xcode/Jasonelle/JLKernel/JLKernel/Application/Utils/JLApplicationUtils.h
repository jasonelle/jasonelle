//
//  JLApplicationUtils.h
//  JLKernel
//
//  Created by clsource on 05-05-22
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
#import <JLKernel/JLUtilsBase64.h>
#import <JLKernel/JLUtilsJSON.h>
#import <JLKernel/JLUtilsFileSystem.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationUtils : NSObject

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

@property (nonatomic, strong, nonnull) JLUtilsBase64 * base64;
@property (nonatomic, strong, nonnull) JLUtilsJSON * json;
@property (nonatomic, strong, nonnull, readonly) NSString * uuid;
@property (nonatomic, strong, nonnull) JLUtilsFileSystem * fs;

- (instancetype) initWithLogger: (id<JLLoggerProtocol>) logger;

@end

NS_ASSUME_NONNULL_END
