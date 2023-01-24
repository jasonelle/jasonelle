//
//  JLJSMessageHandlerOptions.m
//  JLKernel
//
//  Created by Camilo Castro on 24-01-23.
//  Copyright © 2023 Jasonelle.com. All rights reserved.
//

#import "JLJSMessageHandlerOptions.h"

@implementation JLJSMessageHandlerOptions

- (instancetype) initWithValue: (id) value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@", self.value];
}

- (NSNumber *) toNumber {
    return (NSNumber *) self.value;
}

- (NSString *) toString {
    return (NSString *) self.value;
}

- (NSDictionary *) toDictionary {
    if ([self.value respondsToSelector:@selector(objectForKey:)]) {
        return (NSDictionary *) self.value;
    }
    return @{};
}

- (NSArray *) toArray {
    if ([self.value respondsToSelector:@selector(firstObject)]) {
        return (NSArray *) self.value;
    }
    return @[];
}

- (BOOL) toBoolean {
    return [[self toNumber] boolValue];
}

- (JLJSParams *) toParams {
    return [[JLJSParams alloc] initWithDictionary:[self toDictionary]];
}

@end
