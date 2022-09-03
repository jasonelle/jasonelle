//
//  JLEventUserInfo.h
//  JLKernel
//
//  Created by clsource on 24-04-22
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

NS_ASSUME_NONNULL_BEGIN

@interface JLUserInfo : NSObject

@property (nonatomic, strong, nonnull) NSString * name;
@property (nonatomic, strong, nonnull) NSDictionary * data;

- (instancetype) initWithName: (NSString *) name andData: (NSDictionary *) data;
- (instancetype) initWithName: (NSString *) name;

- (NSDictionary *) build;

+ (NSDictionary *) withName: (NSString *) name;
+ (NSDictionary *) withName: (NSString *) name andData: (NSDictionary *) data;

@end

NS_ASSUME_NONNULL_END
