//
//  JLApplicationVersion.h
//  JLKernel
//
//  Created by clsource on 04-05-22
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

//! Project version number for Jasonelle.
FOUNDATION_EXPORT double JasonelleVersionNumber;

//! Project version string for Jasonelle.
FOUNDATION_EXPORT const unsigned char JasonelleVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Jasonelle/PublicHeader.h>


// The Jasonelle Kernel semantic version number components.
#define JASONELLE_VERSION_MAJOR 3
#define JASONELLE_VERSION_MINOR 0
#define JASONELLE_VERSION_PATCH 2

// A human-friendly string representation of the version.
#define JASONELLE_VERSION_STRING "3.0.2"

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
