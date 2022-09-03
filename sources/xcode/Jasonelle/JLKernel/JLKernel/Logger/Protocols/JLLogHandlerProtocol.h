//
//  JLLogHandlerProtocol.h
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
#import <JLKernel/JLLogLevel.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: Implement Multiplex Log Handler
@protocol JLLogHandlerProtocol<NSObject>

@property (nonatomic, strong, nonnull) NSString *label;
@property (nonatomic, strong, nonnull) JLLogLevel *level;
@property (nonatomic, strong, nullable) NSDictionary *metadata;

- (instancetype)initWithLabel:(NSString *)label andLevel:(JLLogLevel *)level;

- (nullable NSString *)log:(JLLogLevel *)level
                   message:(NSString *)message
                  metadata:(nullable NSDictionary *)metadata
                    source:(nullable NSString *)source
                      file:(nullable NSString *)file
                  function:(nullable NSString *)func
                      line:(nullable NSNumber *)line;
@end

NS_ASSUME_NONNULL_END
