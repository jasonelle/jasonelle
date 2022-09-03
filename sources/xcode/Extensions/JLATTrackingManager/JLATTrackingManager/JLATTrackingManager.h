//
//  JLATTrackingManager.h
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
