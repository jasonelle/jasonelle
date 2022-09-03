//
//  JLApplicationBadge.h
//  JLApplicationBadge
//
//  Created by clsource on 06-05-22
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
#import <JLKernel/JLKernel.h>

//! Project version number for JLApplicationBadge.
FOUNDATION_EXPORT double JLApplicationBadgeVersionNumber;

//! Project version string for JLApplicationBadge.
FOUNDATION_EXPORT const unsigned char JLApplicationBadgeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JLApplicationBadge/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationBadge : JLExtension

@property (nonatomic) BOOL granted;
@property (nonatomic, strong, nonnull) NSNumber * number;

- (void) authorize;
- (int) current;
- (void) clear;
- (int) set: (nonnull NSNumber *) number;

@end

NS_ASSUME_NONNULL_END
