//
//  JLJSValue.m
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

#import "JLJSValue.h"

static NSString *RootPath = @"root://";

@implementation JLJSValue

- (NSString *)path {
    if (!_path) {
        _path = RootPath;
    }

    return _path;
}

- (NSString *)type {
    if (!_type) {
        _type = [self getType];
    }

    return _type;
}

- (BOOL)isInRootPath {
    return [self.path isEqualToString:RootPath];
}

- (instancetype)initWithValue:(JSValue *)value {
    self = [super init];

    if (self) {
        self.value = value;
        self.context = value.context;
    }

    return self;
}

- (nullable NSDictionary *)toDictionaryWithDefault:(NSDictionary *)def {
    if (!self.value || (self.value == NULL) || [self.value isUndefined] || [self.value isKindOfClass:[NSNull class]] || ![[self.value toDictionary] isKindOfClass:[NSDictionary class]]) {
        return def;
    }

    return [self.value toDictionary];
}

- (nullable NSDictionary *)toDictionary {
    return [self toDictionaryWithDefault:nil];
}

- (nullable NSNumber *)toNumberWithDefault:(nullable NSNumber *)def {
    if (!self.value || (self.value == NULL) || [self.value isUndefined] || [self.value isKindOfClass:[NSNull class]] || ![[self.value toNumber] isKindOfClass:[NSNumber class]]) {
        return def;
    }

    return [self.value toNumber];
}

- (nullable NSNumber *)toNumber {
    return [self toNumberWithDefault:nil];
}

- (nullable NSString *)toStringWithDefault:(NSString *)def {
    if (!self.value || (self.value == NULL) || [self.value isUndefined] || [self.value isKindOfClass:[NSNull class]] || ![[self.value toString] isKindOfClass:[NSString class]]) {
        return def;
    }

    return [self.value toString];
}

- (nullable NSString *)toString {
    return [self toStringWithDefault:nil];
}

- (BOOL)toBoolWithDefault:(BOOL)def {
    NSNumber *value = [self toNumber];

    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }

    return def;
}

- (BOOL)toBool {
    return [self toBoolWithDefault:NO];
}

- (NSString *)getType {
    JSValue *val = [self.context
                    evaluateScript:[NSString
                                    stringWithFormat:@"typeof %@;",
                                    self.path]];

    return [val toString];
}

- (BOOL)isFunction {
    return [[self getType] isEqualToString:@"function"];
}

- (BOOL)exists {
    NSString *type = [self getType];

    return !([type isEqualToString:@"null"] || [type isEqualToString:@"undefined"] || self.value.isUndefined || self.value.isNull);
}

- (BOOL)canCall {
    return [self isFunction];
}

- (instancetype)callWithArguments:(NSArray *)arguments {
    JSValue *val = [self.value callWithArguments:arguments];

    return [[JLJSValue alloc] initWithValue:val];
}

- (instancetype)callWith:(nullable id)object {
    return [self callWithArguments:@[(object ? object : @{})]];
}

- (instancetype)call {
    return [self callWithArguments:@[]];
}

- (nullable instancetype)secureCallWithArguments:(NSArray *)arguments {
    if (self.canCall) {
        return [self callWithArguments:arguments];
    }

    return nil;
}

- (nullable instancetype)secureCallWith:(nullable id)object {
    return [self secureCallWithArguments:@[(object ? object : @{})]];
}

- (nullable instancetype)secureCall {
    return [self secureCallWithArguments:@[]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"path: %@ | type: %@ | value: %@", self.path, self.type, self.value];
}

@end
