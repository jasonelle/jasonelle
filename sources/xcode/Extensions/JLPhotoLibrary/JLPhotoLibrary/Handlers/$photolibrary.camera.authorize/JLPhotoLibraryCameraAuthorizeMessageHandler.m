//
//  JLPhotoLibraryCameraAuthorizeMessageHandler.m
//  JLPhotoLibrary
//
//  Created by clsource on 03-05-23.
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

#import "JLPhotoLibraryCameraAuthorizeMessageHandler.h"
#import "JLPhotoLibrary.h"
@import AVFoundation;

@implementation JLPhotoLibraryCameraAuthorizeMessageHandler

/// Request authorization for Photo Library access
/// Native Camera Support
/// Add these permissions to info.plist
///    <key>NSCameraUsageDescription</key>
///    <string>If you want to use the camera, you have to give permission.</string>

- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    BOOL showAlert = [[options toParams] boolean:@"showAlert" default:YES];
    
    jlog_trace_join(@"Requesting Camera Access");
    
    if ([self status] == AVAuthorizationStatusDenied) {
        return [self presentAlertWhenDenied];
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted && showAlert) {
            return [self presentAlertWhenDenied];
        }
        jlog_trace_join(@"Camera Access granted? ", jlog_b2s(granted));
        self.resolve(@([self status]));
    }];
}

- (AVAuthorizationStatus) status {
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

- (void) presentAlertWhenDenied {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Camera Access", @"JLPhotoLibraryCameraAlertTitle. Alert title when Camera Access is Denied") message:NSLocalizedString(@"This app requires access to your Camera.", @"JLPhotoLibraryCameraAlertMessage. Alert message when Camera Access is Denied") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        jlog_trace(@"Canceled Camera Alert.");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Go to Settings Button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.app.utils openSettings];
    }]];

    [self.app.utils present:alert completion:^{
        jlog_trace(@"Presented Camera Not Authorized Alert.");
        self.resolve(@([self status]));
    }];
}

@end
