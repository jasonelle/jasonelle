//
//  JLEventUserInfo.m
//  JLKernel
//
//  Created by clsource on 24-04-22
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

#import "JLUserInfo.h"

@implementation JLUserInfo

- (instancetype)initWithName:(NSString *)name andData:(NSDictionary *)data {
    self = [super init];

    if (self) {
        self.name = name;
        self.data = data;
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name andData:@{}];
}

- (NSDictionary *)build {
    return @{ @"name": self.name, @"data": self.data };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ | data: %@", self.name, self.data];
}

+ (NSDictionary *)withName:(NSString *)name andData:(NSDictionary *)data {
    return [[[self alloc] initWithName:name andData:data] build];
}

+ (NSDictionary *)withName:(NSString *)name {
    return [[[self alloc] initWithName:name] build];
}

@end
