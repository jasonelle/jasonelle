//
//  JLApplicationVersion.h
//  JLKernel
//
//  Created by clsource on 04-05-22
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

//! Project version number for Jasonelle.
FOUNDATION_EXPORT double JasonelleVersionNumber;

//! Project version string for Jasonelle.
FOUNDATION_EXPORT const unsigned char JasonelleVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Jasonelle/PublicHeader.h>


// The Jasonelle Kernel semantic version number components.
#define JASONELLE_VERSION_MAJOR 3
#define JASONELLE_VERSION_MINOR 0
#define JASONELLE_VERSION_PATCH 0

// A human-friendly string representation of the version.
#define JASONELLE_VERSION_STRING "3.0.0"

// A monotonically increasing numeric representation of the version number. Use
// this if you want to do range checks over versions.
#define JASONELLE_VERSION_NUMBER (JASONELLE_VERSION_MAJOR * 1000000 +                    \
                                  JASONELLE_VERSION_MINOR * 1000 +                       \
                                  JASONELLE_VERSION_PATCH)

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationVersion : NSObject

@property (nonatomic, strong, nonnull) NSString * string;
@property (nonatomic, strong, nonnull) NSNumber * number;
@property (nonatomic, strong, nonnull) NSDictionary * dictionary;

/// Checks the current version with the provided number
/// and returns `true` if the number is at least
- (BOOL) atLeast: (int) major minor: (int) minor patch: (int) patch;
- (BOOL) atLeast: (int) major;
@end

NS_ASSUME_NONNULL_END
