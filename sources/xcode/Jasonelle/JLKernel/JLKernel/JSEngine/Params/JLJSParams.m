//
//  JLJSParams.m
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


#import <JLKernel/JLJSParams.h>

@implementation JLJSParams

- (NSString *) path {
    if (!_path) {
        _path = self.value ? self.value.path : @"root://";
    }
    return _path;
}

- (NSDictionary *) dictionary {
    if (!_dictionary) {
        _dictionary = @{};
    }
    return _dictionary;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@: %@", self.path, self.dictionary];
}

- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

- (instancetype) initWithDictionary: (NSDictionary *) dictionary
                            context: (JLJSContext *) context
                           andValue: (JLJSValue *) value {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.context = context;
        self.logger = context.logger;
        self.value = value;
    }
    return self;
}

- (instancetype) get: (NSString *) key {
    
    JLJSParams * params = [[[self class] alloc]
                           initWithDictionary:[self dictionary:key default:@{}]];
    
    // Store the parent for traversal as a linked list
    params.parent = self;
    
    params.context = self.context;
    params.logger = self.logger;
    
    // The value must be obtained so the path can be properly set
    params.value = [self value:key];
    
    // Store the child for traversal as a linked list
    self.child = params;
    
    return params;
}

- (BOOL) exists: (NSString *) key {
    NSDictionary * outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

- (nullable NSDictionary *) dictionary: (NSString *) key default: (nullable NSDictionary *) def {
    NSDictionary * outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return def;
    }
    return outvar;
}

- (nullable NSDictionary *) dictionary: (NSString *) key {
    return [self dictionary:key default:@{}];
}

- (nullable NSArray *) array: (NSString *) key default: (nullable NSArray *) def {
    NSArray * outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return def;
    }
    return outvar;
}

- (nullable NSArray *) array: (NSString *) key {
    return [self array:key default:@[]];
}

- (nullable NSNumber *) number: (NSString *) key default: (nullable NSNumber *) def {
    NSNumber * outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return def;
    }
    return outvar;
}

- (nullable NSNumber *) number: (NSString *) key {
    return [self number:key default:nil];
}

- (nullable NSString *) string: (NSString *) key default: (nullable NSString *) def {
    NSString * outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return def;
    }
    return outvar;
}

- (nullable NSString *) string: (NSString *) key {
    return [self string:key default:nil];
}

- (BOOL) boolean: (NSString *) key default: (BOOL) boolean {
    NSNumber * outvar = self.dictionary[key];
    
    // IF the value is null then return false
    if (outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    // If the value is a number then check the boolean result
    if([outvar isKindOfClass:[NSNumber class]]) {
        return [outvar boolValue];
    }
    
    // Any other value is the default given
    return boolean;
}

- (BOOL) boolean: (NSString *) key {
    return [self boolean:key default:YES];
}

- (id) any: (NSString *) key default: (nullable id) def {
    id outvar = self.dictionary[key];
    if (!outvar || outvar == NULL || [outvar isKindOfClass:[NSNull class]]) {
        return def;
    }
    return outvar;
}

- (id) any: (NSString *) key {
    return [self any:key default:nil];
}

- (JLJSValue *) value: (NSString *) key {
    // We will fetch the value from the JSContext using JS Object Bracket Notation
    // The path to the object is defined by the parent value's path
    // use backticks so the key can have single and double quotes?
    // Do not put ; at the end because we would need to concatenate it later
    NSString * path = [NSString stringWithFormat:@"%@[`%@`]", self.value.path, key];
    
    // If the path is empty this means the variable is inside the global context
    // It will have @"root://" as the default path
    if ([self.value isInRootPath]) {
        path = key;
    }
    
    // Getting values directly from the JSContext is needed
    // because when transforming to NSDictionaries the functions are lost
    // since they cannot be converted to JSON.
    // So we need to obtain their value directly, so we have a function reference
    // to call it later.
    JLJSValue * outvar = [self.context eval:[NSString stringWithFormat:@"%@;", path] withSourceURLString:@"com.jasonelle.kernel.params"];
    
    // Set the path so we can use it for the next value
    // forming a tree structure
    outvar.path = path;
    
    return outvar;
}
@end
