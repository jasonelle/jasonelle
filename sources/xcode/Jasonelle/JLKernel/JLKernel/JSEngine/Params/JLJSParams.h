//
//  JLJSParams.h
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
#import <JLKernel/JLJSValue.h>
#import <JLKernel/JLJSContext.h>

NS_ASSUME_NONNULL_BEGIN

/// Helper functions to deal with Params from JSContext interop
@interface JLJSParams : NSObject
@property (nonatomic, strong, nonnull) NSDictionary * dictionary;

// So we can traverse the properties of an object and generate a linked list like structure
@property (nonatomic, strong, nonnull) NSString * path;
@property (nonatomic, strong, nonnull) JLJSParams * parent;
@property (nonatomic, strong, nonnull) JLJSParams * child;

@property (nonatomic, strong, nonnull) JLJSContext * context;
@property (nonatomic, strong, nonnull) JLJSValue * value;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;


- (instancetype) initWithDictionary: (NSDictionary *) params;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary
                            context: (JLJSContext *) context
                              andValue: (JLJSValue *) value;

/// A dictionary converted to Params
- (instancetype) get: (NSString *) key;

- (nullable NSDictionary *) dictionary: (NSString *) key default: (nullable NSDictionary *) def;
- (nullable NSDictionary *) dictionary: (NSString *) key;

- (nullable NSNumber *) number: (NSString *) key default: (nullable NSNumber *) def;
- (nullable NSNumber *) number: (NSString *) key;

- (nullable NSString *) string: (NSString *) key default: (nullable NSString *) def;
- (nullable NSString *) string: (NSString *) key;

- (BOOL) boolean: (NSString *) key;

- (JLJSValue *) value: (NSString *) key;

@end

NS_ASSUME_NONNULL_END
