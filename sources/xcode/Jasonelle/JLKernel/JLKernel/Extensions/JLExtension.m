//
//  JLExtension.m
//  JLKernel
//
//  Created by clsource on 06-05-22
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

#import "JLExtension.h"

static NSString *NAMESPACE = @"com.jasonelle.app.extensions";

@implementation JLExtension

@synthesize app;
@synthesize logger;
@synthesize name = _name;
@synthesize handlers = _handlers;

- (NSDictionary *)handlers {
    if (!_handlers) {
        _handlers = @{};
    }
    return _handlers;
}

- (NSString *)name {
    if (!_name) {
        _name = [[self class] name];
    }

    return _name;
}

- (void)install {
    // Override in child and call super
    jlog_trace_join(@"Installing: ", self.name);
}

#pragma mark - Instance Methods
- (instancetype)initWithName:(NSString *)name
                      logger:(nonnull id<JLLoggerProtocol>)logger
                      andApp:(nonnull JLApplication *)app {
    self = [super init];

    if (self) {
        self.name = name;
        self.logger = logger;
        self.app = app;
    }

    return self;
}

- (NSDictionary *)installHandlers:(NSDictionary *)handlers {
    // Can Override in Child if you implement WebView Handlers
    NSMutableDictionary *newHandlers = [handlers mutableCopy];

    for (NSString *key in self.handlers.allKeys) {
        [newHandlers setObject:self.handlers[key] forKey:key];
    }

    return [newHandlers copy];
}

#pragma mark - Class methods

+ (instancetype)instanceWithLogger:(id<JLLoggerProtocol>)logger
                            andApp:(JLApplication *)app {
    return [[[self class] alloc] initWithName:[self name] logger:logger andApp:app];
}

+ (NSString *)namespaceForClass:(Class)class {
    return [NSString stringWithFormat:@"%@.%@", NAMESPACE, NSStringFromClass(class)];
}

+ (NSString *)name {
    return [self namespaceForClass:[self class]];
}

@end
