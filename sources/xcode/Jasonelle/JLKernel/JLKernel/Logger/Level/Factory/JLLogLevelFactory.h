//
//  JLLogLevelFactory.h
//  JLKernel
//
//  Created by clsource on 02-02-22
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
#import <JLKernel/JLLogLevel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLLogLevelFactory : NSObject

+ (JLLogLevel *)trace;
+ (JLLogLevel *)debug;
+ (JLLogLevel *)info;
+ (JLLogLevel *)notice;
+ (JLLogLevel *)warning;
+ (JLLogLevel *)error;
+ (JLLogLevel *)critical;
+ (JLLogLevel *)disabled;
+ (NSDictionary *)all;
+ (JLLogLevel *)for:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
