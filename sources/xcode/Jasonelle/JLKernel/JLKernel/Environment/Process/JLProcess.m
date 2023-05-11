//
//  JLProcess.m
//  JLKernel
//
//  Created by clsource on 03-02-22
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

#import "JLProcess.h"

@implementation JLProcess

- (nonnull NSBundle *)bundle {
    return [NSBundle mainBundle];
}

- (nonnull NSDictionary *)environment {
    return [[NSProcessInfo processInfo] environment];
}

- (nonnull NSUserDefaults *)storage {
    return [NSUserDefaults standardUserDefaults];
}

- (nonnull UIScreen *)screen {
    return [UIScreen mainScreen];
}

- (nonnull NSDictionary *)info {
    return [self.bundle infoDictionary];
}

- (nonnull NSDictionary *)device {
    UIDevice *device = [UIDevice currentDevice];
    CGRect frame = self.screen.bounds;

    return @{
        @"device": @{
            @"name": device.name,
            @"model": @{
                @"name": device.model,
                @"localized": device.localizedModel
            },
            @"system": @{
                @"name": device.systemName,
                @"version": device.systemVersion,
                @"simulator": @(self.environment[@"SIMULATOR_DEVICE_NAME"] != nil)
            },
            @"size": @{
                @"width": @(frame.size.width),
                @"height": @(frame.size.height)
            },
            @"orientation": @{
                @"id": @(device.orientation),
                @"portrait": @(UIDeviceOrientationIsPortrait(device.orientation)),
            },
        }
    };
}

// TODO: Add more identifiers
// An identifier for:
// Unique installation identifier. Only for this app install
// Unique app run identifier. Generated on each app load.
- (nonnull NSDictionary *)identifiers {
    UIDevice *device = [UIDevice currentDevice];

    return @{
        // The value of this property is the same for apps that come from the same vendor running on the same device. A different value is returned for apps on the same device that come from different vendors, and for apps on different devices regardless of vendor.
        // see: https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor?language=objc
        @"vendor": device.identifierForVendor.UUIDString,
    };
}

- (NSDictionary *) toDictionary {
    return @{
        @"device": self.device[@"device"],
        @"identifiers": self.identifiers
    };
}

@end
