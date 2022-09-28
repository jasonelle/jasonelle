//
//  JLATTrackingManager.h
//
//  Created by clsource on 24-04-22
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

// Optionally install ATTracking Support
// Request user authorization to access app-related data for tracking the user or the device.
// Ensure to configure the plist as well.
// If your app calls the App Tracking Transparency API, you must provide custom text, known as a usage-description string, which displays as a system-permission alert request. The usage-description string tells the user why the app is requesting permission to use data for tracking the user or the device.
// https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription?language=objc

#import <Foundation/Foundation.h>
#import <JLKernel/JLKernel.h>

NS_ASSUME_NONNULL_BEGIN

/// Request user authorization to access app-related data for tracking the user or the device.
/// https://developer.apple.com/documentation/apptrackingtransparency
/// https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription?language=objc
@interface JLATTrackingManager : JLExtension
 /// https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanagerauthorizationstatus?language=objc
@property (nonatomic, strong, nonnull) NSNumber * status;

@end

NS_ASSUME_NONNULL_END
