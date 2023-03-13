//
//  JLEvent.m
//  JLKernel
//
//  Created by clsource on 22-04-22
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
        self.identifier = name;
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

- (void) triggerWithObject: (nullable id) object {
    NSString *name = [[self class] name];

    NSDate *now = [NSDate date];
    NSTimeInterval ts = [now timeIntervalSince1970];

    self.triggeredAt = @(ts);

    [self.center
     post:name
     by:(object ? object : self)
     with:[JLUserInfo
           withName:name
           andClass:[self class]
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

+ (NSNotificationName) notificationName {
    return (NSNotificationName) [self name];
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
