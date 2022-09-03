//
//  JLEvent.m
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

#import "JLEvent.h"
#import <JLKernel/JLUserInfo.h>

static NSString *NAMESPACE = @"com.jasonelle.app.events";

@implementation JLEvent

- (NSDictionary *)event {
    if (!_event) {
        _event = [JLUserInfo
                  withName:self.name];
    }

    return _event;
}

- (NSNumber *)triggeredAt {
    if (!_triggeredAt) {
        NSDate *now = [NSDate date];
        NSTimeInterval ts = [now timeIntervalSince1970];
        _triggeredAt = @(ts);
    }

    return _triggeredAt;
}

- (instancetype)initWithName:(NSString *)name
                      center:(JLNotificationCenter *)center
                   andLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];

    if (self) {
        self.name = name;
        self.center = center;
        self.logger = logger;
        self.active = NO;
        self.triggered = NO;
        self.triggeredAt = @([[NSDate date] timeIntervalSince1970]);
    }

    return self;
}

- (instancetype)initWithCenter:(JLNotificationCenter *)center
                     andLogger:(id<JLLoggerProtocol>)logger {
    return [self
            initWithName:[[self class] name]
                  center:center
               andLogger:logger];
}

- (void)uninstall {
    // Call this with [super uninstall] in child
    self.active = NO;
    jlog_trace_join(self.name, @" Uninstalled");
}

- (void)install {
    // Call this with [super install] in child
    self.active = YES;
    jlog_trace_join(self.name, @" Installed");
}

- (void)triggerWithParams:(nullable id)params {
    NSString *name = [[self class] name];

    NSDate *now = [NSDate date];
    NSTimeInterval ts = [now timeIntervalSince1970];

    self.triggeredAt = @(ts);

    [self.center
     post:name
       by:self
     with:[JLUserInfo
           withName:name
            andData:(params ? [params
                              isKindOfClass:[NSDictionary class]] ? params : @{ @"data": params } : nil)
     ]
    ];
}

- (void)trigger {
    return [self triggerWithParams:@{}];
}

- (void)triggerOnce {
    if (!self.triggered) {
        self.triggered = YES;
        [self trigger];
    }
}

- (void)triggerAfterMilliseconds:(NSTimeInterval)ms withParams:(nullable id)params {
    NSDate *now = [NSDate date];
    NSTimeInterval ts = [self.triggeredAt doubleValue];
    NSTimeInterval diff = [now timeIntervalSince1970] - ts;

    if (diff >= ms) {
        [self triggerWithParams:params];
    }
}

- (void)triggerAfterMilliseconds:(NSTimeInterval)ms {
    return [self triggerAfterMilliseconds:ms withParams:@{}];
}

- (void)listenWith:(id)observer for:(SEL)target {
    [[self class] listenIn:self.center with:observer for:target];
}

/// Start monitoring for notifications
- (void)startMonitoring {
    // Override in Child if needed
}

/// Start monitoring for notifications
- (void)stopMonitoring {
    // Override in Child if needed
}

+ (NSString *)namespaceForClass:(Class)class {
    return [NSString stringWithFormat:@"%@.%@", NAMESPACE, NSStringFromClass(class)];
}

+ (NSString *)name {
    return [self namespaceForClass:[self class]];
}

+ (void)listenIn:(JLNotificationCenter *)center
            with:(id)observer
             for:(SEL)target {
    [center.center
     addObserver:observer
        selector:target
            name:[self name]
          object:nil];
}

@end
