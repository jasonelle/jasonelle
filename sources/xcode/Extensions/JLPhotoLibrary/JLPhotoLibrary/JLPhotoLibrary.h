//
//  JLPhotoLibrary.h
//  JLPhotoLibrary
//
//  Created by clsource on 11-01-23
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
#import <JLKernel/JLKernel.h>

//! Project version number for JLPhotoLibrary.
FOUNDATION_EXPORT double JLPhotoLibraryVersionNumber;

//! Project version string for JLPhotoLibrary.
FOUNDATION_EXPORT const unsigned char JLPhotoLibraryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JLPhotoLibrary/PublicHeader.h>


NS_ASSUME_NONNULL_BEGIN

@interface JLPhotoLibrary : JLExtension

/// Tells if the photo library access permission was granted
@property (nonatomic) BOOL granted;

/// Request authorization for Photo Library access
/// Native Camera Support
/// Add these permissions to info.plist
///
///    <key>NSPhotoLibraryUsageDescription</key>
///    <string>If you want to use the photolibrary, you have to give permission.</string>
///    <key>NSCameraUsageDescription</key>
///    <string>If you want to use the camera, you have to give permission.</string>
- (NSInteger) authorize;
- (NSInteger) status;

/// Show an alert to indicate go to settings to change the denied permissions
/// Avoid calling alert() in JS after this alert is presented or it will crash the app
/// Since the alerts are created without completionhandler.
/// TODO: Maybe create the alert using the alert prompt in WKWebview but with JSON params?
- (NSInteger) presentAlertWhenDenied;

@end

NS_ASSUME_NONNULL_END
