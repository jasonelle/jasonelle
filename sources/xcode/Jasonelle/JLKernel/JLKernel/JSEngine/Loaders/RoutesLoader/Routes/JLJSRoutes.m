//
//  JLJSRoutes.m
//  JLKernel
//
//  Created by clsource on 21-04-22
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

#import "JLJSRoutes.h"

@implementation JLJSRoutes

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           context:(JLJSContext *)context
                          andValue:(JLJSValue *)value {
    self = [super init];

    if (self) {
        self.dict = dictionary;
        self.context = context;
        self.logger = context.logger;
        self.value = value;

        self.params = [[JLJSParams alloc]
                       initWithDictionary:dictionary
                                  context:context
                                 andValue:value];
    }

    return self;
}

- (NSString *)description {
    return self.dict.description;
}

@end
