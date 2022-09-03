//
//  JLApplicationEvents.m
//  JLKernel
//
//  Created by clsource on 22-04-22
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

#import <JLKernel/JLApplicationEvents.h>

@implementation JLApplicationEvents

- (NSDictionary *)registry {
    if (!_registry) {
        _registry = @{};
    }

    return _registry;
}

- (NSArray<JLEvent *> *)add:(JLEvent *)event {
    if (event) {
        NSMutableDictionary *dic = [self.registry mutableCopy];
        [event install];
        [dic setObject:event forKey:event.name];
        self.registry = [dic copy];
    }

    return [self.registry allValues];
}

- (NSArray<JLEvent *> *)remove:(NSString *)name {
    JLEvent *event = [self.registry objectForKey:name];

    return [self removeEvent:event];
}

- (NSArray<JLEvent *> *)removeEvent:(JLEvent *)event {
    if (event) {
        NSMutableDictionary *dic = [self.registry mutableCopy];
        [dic removeObjectForKey:event.name];
        self.registry = [dic copy];
    }

    return [self.registry allValues];
}

// TODO: rename as 'get'
- (JLEvent *)eventFor:(Class)eventClass {
    return self.registry[[JLEvent namespaceForClass:eventClass]];
}

- (void)addListener:(id)object with:(SEL)target for:(Class)eventClass {
    JLEvent *event = [self.registry objectForKey:[JLEvent namespaceForClass:eventClass]];

    if ([event isKindOfClass:[JLEvent class]]) {
        [event listenWith:object for:target];
    }
}

@end
