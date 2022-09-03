//
//  JLApplicationEvents.h
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
#import <JLKernel/JLEvent.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationEvents : NSObject

@property (nonatomic, strong, nonnull) NSDictionary * registry;

- (NSArray<JLEvent *> *) add: (JLEvent *) event;
- (NSArray<JLEvent *> *) remove: (NSString *) name;
- (NSArray<JLEvent *> *) removeEvent: (JLEvent *) event;
- (nullable JLEvent *) eventFor: (Class) eventClass;

- (void) addListener: (id) object with: (SEL) target for: (Class) eventClass;


@end

NS_ASSUME_NONNULL_END
