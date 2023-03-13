//
//  JLJSParams.h
//  JLKernel
//
//  Created by clsource on 14-04-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
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

/// Tells if the given key exists in the dictionary
- (BOOL) exists: (NSString *) key;

- (nullable NSDictionary *) dictionary: (NSString *) key default: (nullable NSDictionary *) def;
- (nullable NSDictionary *) dictionary: (NSString *) key;

- (nullable NSArray *) array: (NSString *) key default: (nullable NSArray *) def;
- (nullable NSArray *) array: (NSString *) key;

- (nullable NSNumber *) number: (NSString *) key default: (nullable NSNumber *) def;
- (nullable NSNumber *) number: (NSString *) key;

- (nullable NSString *) string: (NSString *) key default: (nullable NSString *) def;
- (nullable NSString *) string: (NSString *) key;

- (nullable id) any: (NSString *) key default: (nullable id) def;
- (nullable id) any: (NSString *) key;

- (BOOL) boolean: (NSString *) key default: (BOOL) boolean;
- (BOOL) boolean: (NSString *) key;

- (JLJSValue *) value: (NSString *) key;

@end

NS_ASSUME_NONNULL_END
