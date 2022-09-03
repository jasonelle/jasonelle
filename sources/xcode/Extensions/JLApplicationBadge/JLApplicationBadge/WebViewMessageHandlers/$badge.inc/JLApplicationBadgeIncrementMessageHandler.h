//
//  JLApplicationBadgeIncrementMessageHandler.h
//  JLApplicationBadge
//
//  Created by clsource on 01-09-22
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


#import <JLKernel/JLKernel.h>
@class JLApplicationBadge;

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationBadgeIncrementMessageHandler : JLJSMessageHandler
@property (nonatomic, nonnull) JLApplicationBadge * badge;
@end

NS_ASSUME_NONNULL_END
