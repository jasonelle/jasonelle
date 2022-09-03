//
//  JLEvent.h
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


#import <Foundation/Foundation.h>
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLNotificationCenter.h>
#import <JLKernel/JLEnvironment.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEvent : NSObject

@property (nonatomic, strong, nonnull) NSString * name;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) JLNotificationCenter * center;
@property (nonatomic, strong, nonnull) JLEnvironment * env;
/// Event dictionary for passing to JS hooks
@property (nonatomic, strong, nonnull) NSDictionary * event;
@property (nonatomic, strong, nonnull) NSNumber * triggeredAt;
@property (nonatomic) BOOL triggered;

@property (nonatomic) BOOL active;

- (instancetype) initWithName: (NSString *) name
                       center: (JLNotificationCenter *) center
                    andLogger: (id<JLLoggerProtocol>) logger;

- (instancetype) initWithCenter:(JLNotificationCenter *) center
                      andLogger: (id<JLLoggerProtocol>) logger;
- (void) install;
- (void) uninstall;
- (void) triggerWithParams: (nullable id) params;
- (void) trigger;
- (void) triggerOnce;

/// Trigger the event after x milliseconds from the last trigger timestamp
- (void) triggerAfterMilliseconds:(NSTimeInterval) ms withParams: (nullable id) params;
- (void) triggerAfterMilliseconds:(NSTimeInterval) ms;

- (void) listenWith: (id) observer for: (SEL) target;

/// Start monitoring for notifications
- (void) startMonitoring;

/// Stop monitoring for notifications
- (void) stopMonitoring;

+ (NSString *) namespaceForClass: (Class) class;
+ (NSString *) name;

+ (void) listenIn:(JLNotificationCenter *) center
                     with: (id) observer
                     for: (SEL) target;

@end

NS_ASSUME_NONNULL_END
