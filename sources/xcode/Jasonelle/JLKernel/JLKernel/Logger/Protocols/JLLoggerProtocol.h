//
//  JLLoggerProtocol.h
//  JLKernel
//
//  Created by clsource on 02-02-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  https://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>
#import <JLKernel/JLLogLevel.h>
#import <JLKernel/JLLogHandlerProtocol.h>
#import <JLKernel/JLLoggerMacros.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLLoggerProtocol<NSObject>

@property (nonatomic, strong, nonnull) NSString *label;
@property (nonatomic, strong, nonnull) id<JLLogHandlerProtocol> handler;
@property (nonatomic, strong, nullable) NSDictionary *metadata;

- (instancetype)initWithLabel:(NSString *)label andHandler:(id<JLLogHandlerProtocol>)handler;

- (nullable NSString *)log:(JLLogLevel *)level
                   message:(NSString *)message
                  metadata:(nullable NSDictionary *)metadata
                    source:(nullable NSString *)source
                      file:(nullable NSString *)file
                  function:(nullable NSString *)func
                      line:(nullable NSNumber *)line;

#pragma mark - Log Levels
#pragma mark Trace

- (nullable NSString *)trace:(nonnull NSString *)message;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)trace:(nonnull NSString *)message
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)trace:(nonnull NSString *)message
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)trace:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)trace:(nonnull NSString *)message
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

#pragma mark Debug
- (nullable NSString *)debug:(nonnull NSString *)message;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)debug:(nonnull NSString *)message
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)debug:(nonnull NSString *)message
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)debug:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)debug:(nonnull NSString *)message
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

#pragma mark Info
- (nullable NSString *)info:(nonnull NSString *)message;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                     source:(nullable NSString *)source
                       file:(nullable NSString *)file
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                     source:(nullable NSString *)source
                       file:(nullable NSString *)file
                   function:(nullable NSString *)func;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                     source:(nullable NSString *)source
                       file:(nullable NSString *)file;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                     source:(nullable NSString *)source;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                       file:(nullable NSString *)file
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

- (nullable NSString *)info:(nonnull NSString *)message
                     source:(nullable NSString *)source
                       file:(nullable NSString *)file
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

- (nullable NSString *)info:(nonnull NSString *)message
                       file:(nullable NSString *)file
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

- (nullable NSString *)info:(nonnull NSString *)message
                   metadata:(nullable NSDictionary *)metadata
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

- (nullable NSString *)info:(nonnull NSString *)message
                   function:(nullable NSString *)func
                       line:(nullable NSNumber *)line;

#pragma mark Notice

- (nullable NSString *)notice:(nonnull NSString *)message;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                       source:(nullable NSString *)source
                         file:(nullable NSString *)file
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                       source:(nullable NSString *)source
                         file:(nullable NSString *)file
                     function:(nullable NSString *)func;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                       source:(nullable NSString *)source
                         file:(nullable NSString *)file;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                       source:(nullable NSString *)source;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                         file:(nullable NSString *)file
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

- (nullable NSString *)notice:(nonnull NSString *)message
                       source:(nullable NSString *)source
                         file:(nullable NSString *)file
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

- (nullable NSString *)notice:(nonnull NSString *)message
                         file:(nullable NSString *)file
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

- (nullable NSString *)notice:(nonnull NSString *)message
                     metadata:(nullable NSDictionary *)metadata
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

- (nullable NSString *)notice:(nonnull NSString *)message
                     function:(nullable NSString *)func
                         line:(nullable NSNumber *)line;

#pragma mark Warning
- (nullable NSString *)warning:(nonnull NSString *)message;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                        source:(nullable NSString *)source
                          file:(nullable NSString *)file
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                        source:(nullable NSString *)source
                          file:(nullable NSString *)file
                      function:(nullable NSString *)func;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                        source:(nullable NSString *)source
                          file:(nullable NSString *)file;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                        source:(nullable NSString *)source;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                          file:(nullable NSString *)file
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

- (nullable NSString *)warning:(nonnull NSString *)message
                        source:(nullable NSString *)source
                          file:(nullable NSString *)file
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

- (nullable NSString *)warning:(nonnull NSString *)message
                          file:(nullable NSString *)file
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

- (nullable NSString *)warning:(nonnull NSString *)message
                      metadata:(nullable NSDictionary *)metadata
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

- (nullable NSString *)warning:(nonnull NSString *)message
                      function:(nullable NSString *)func
                          line:(nullable NSNumber *)line;

#pragma mark Error
- (nullable NSString *)error:(nonnull NSString *)message;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                      source:(nullable NSString *)source;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)error:(nonnull NSString *)message
                      source:(nullable NSString *)source
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)error:(nonnull NSString *)message
                        file:(nullable NSString *)file
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)error:(nonnull NSString *)message
                    metadata:(nullable NSDictionary *)metadata
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

- (nullable NSString *)error:(nonnull NSString *)message
                    function:(nullable NSString *)func
                        line:(nullable NSNumber *)line;

#pragma mark Critical

- (nullable NSString *)critical:(nonnull NSString *)message;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                         source:(nullable NSString *)source
                           file:(nullable NSString *)file
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                         source:(nullable NSString *)source
                           file:(nullable NSString *)file
                       function:(nullable NSString *)func;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                         source:(nullable NSString *)source
                           file:(nullable NSString *)file;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                         source:(nullable NSString *)source;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                           file:(nullable NSString *)file
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;

- (nullable NSString *)critical:(nonnull NSString *)message
                         source:(nullable NSString *)source
                           file:(nullable NSString *)file
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;

- (nullable NSString *)critical:(nonnull NSString *)message
                           file:(nullable NSString *)file
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;

- (nullable NSString *)critical:(nonnull NSString *)message
                       metadata:(nullable NSDictionary *)metadata
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;

- (nullable NSString *)critical:(nonnull NSString *)message
                       function:(nullable NSString *)func
                           line:(nullable NSNumber *)line;
@end

NS_ASSUME_NONNULL_END
