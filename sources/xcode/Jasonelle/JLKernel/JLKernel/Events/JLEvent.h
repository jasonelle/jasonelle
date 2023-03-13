//
//  JLEvent.h
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


#import <Foundation/Foundation.h>
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLNotificationCenter.h>
#import <JLKernel/JLEnvironment.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEvent : NSObject

@property (nonatomic, strong, nonnull) NSString * name;
@property (nonatomic, strong, nonnull) NSNotificationName identifier;
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
- (void) triggerWithObject: (nullable id) object;
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
+ (NSNotificationName) notificationName;

+ (void) listenIn:(JLNotificationCenter *) center
                     with: (id) observer
                     for: (SEL) target;

@end

NS_ASSUME_NONNULL_END
