//
//  JLReachability.h
//  JLReachability
//
//  Created by clsource on 26-02-23.
//
//  Copyright (c) Jasonelle.com
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
#import <JLKernel/JLKernel.h>
#import <JLReachability/TonyReachability.h>

//! Project version number for JLReachability.
FOUNDATION_EXPORT double JLReachabilityVersionNumber;

//! Project version string for JLReachability.
FOUNDATION_EXPORT const unsigned char JLReachabilityVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JLReachability/PublicHeader.h>

@interface JLReachability : JLExtension

/// Returns the reachbility object
@property (nonatomic, strong, nonnull) TonyReachability * reach;

@property (nonatomic, strong, nonnull) NSString * label;
@property (nonatomic, strong, nonnull) NSNumber * status;
@property (nonatomic, strong, nonnull) NSNumber * reachable;

// TODO: Maybe in the future allow other kinds of reachabilities. Like for a specific Hostname in the configuration.

// NOTE: System Configuration is Available in iOS and Mac Catalyst
// But, Mac Catalyst have the problem to be linked to the MacOS framework
// This means that if the user have a newer MacOS then it will try to look
// For the older MacOS Framework causing build problems.
// Is best to leave SystemConfiguration.framework without Mac Catalyst for now
// until a way to not depend on the MacOS version.
// Otherwise it would require to manually add the SystemConfiguration framework for each user.

- (nonnull NSDictionary *) result;

@end
