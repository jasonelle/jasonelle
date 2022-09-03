//
//  JLNotificationCenter.h
//  JLKernel
//
//  Created by clsource on 19-04-22
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

NS_ASSUME_NONNULL_BEGIN

@interface JLNotificationCenter : NSObject

@property (nonatomic, strong, nonnull) NSNotificationCenter * center;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

- (instancetype) initWithLogger: (id<JLLoggerProtocol>) logger;

- (NSNotification *) post: (NSString *) name
                         by: (nullable id) object
                       with: (nullable NSDictionary *) content;
@end

NS_ASSUME_NONNULL_END
