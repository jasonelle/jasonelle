//
//  JLJSValue.h
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
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

/// Helper functions to handle JSValues
@interface JLJSValue : NSObject
@property (nonatomic, strong, nonnull) JSValue * value;
@property (nonatomic, strong, nonnull) JSContext * context;
@property (nonatomic, strong, nonnull) NSString * type;

// The path were this was created
// So we can find later the variable in the context
@property (nonatomic, strong, nonnull) NSString * path;

- (instancetype) initWithValue: (JSValue *) value;

- (nullable NSDictionary *) toDictionaryWithDefault: (nullable NSDictionary *) def;
- (nullable NSDictionary *) toDictionary;

- (nullable NSNumber *) toNumberWithDefault: (nullable NSNumber *) def;
- (nullable NSNumber *) toNumber;

- (nullable NSString *) toStringWithDefault: (nullable NSString *) def;
- (nullable NSString *) toString;

- (BOOL) toBoolWithDefault: (BOOL) def;
- (BOOL) toBool;

- (instancetype) callWithArguments: (NSArray *) arguments;
- (instancetype) callWith: (nullable id) object;
- (instancetype) call;
- (BOOL) canCall;

// Allow calling only when canCall is true
- (nullable instancetype) secureCallWithArguments: (NSArray *) arguments;
- (nullable instancetype) secureCallWith: (nullable id) object;
- (nullable instancetype) secureCall;

- (BOOL) isInRootPath;
- (BOOL) exists;

@end

NS_ASSUME_NONNULL_END
