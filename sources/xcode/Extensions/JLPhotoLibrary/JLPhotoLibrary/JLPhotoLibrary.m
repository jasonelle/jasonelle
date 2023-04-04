//
//  JLPhotoLibrary.m
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

#import "JLPhotoLibrary.h"
#import "JLPhotoLibraryGrantedHandler.h"
#import "JLPhotoLibraryAuthorizeHandler.h"
#import "JLPhotoLibraryAlertHandler.h"

@import Photos;

@implementation JLPhotoLibrary

- (void) install {
    [super install];
    
    self.handlers = @{
        @"$photolibrary.granted": [[JLPhotoLibraryGrantedHandler alloc] initWithApplication:self.app andExtension:self],
        @"$photolibrary.authorize": [[JLPhotoLibraryAuthorizeHandler alloc] initWithApplication:self.app andExtension:self],
        @"$photolibrary.alert": [[JLPhotoLibraryAlertHandler alloc] initWithApplication:self.app andExtension:self]
        // TODO: ,@"photolibrary.update" // For limited status
    };
}

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    // Install the wrappers inside the webview
    return [self.app.utils.webview inject:self intoWebView:webView];
}

- (NSInteger) presentAlertWhenDenied {
    NSURL * settingsAppURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Photo Library Access", @"JLPhotoLibraryAlertTitle. Alert title when Photo Library Access is Denied") message:NSLocalizedString(@"This app requires access to your Photo Library.", @"JLPhotoLibraryAlertMessage. Alert message when Photo Library Access is Denied") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        jlog_trace(@"Canceled Photo Library Alert.");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Go to Settings Button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:settingsAppURL options:@{} completionHandler:^(BOOL success) {
            jlog_trace(@"Opened Settings URL from Photo Library Alert.");
        }];
    }]];

    [self.app.rootController presentViewController:alert animated:YES completion:^{
        jlog_trace(@"Presented Photo Library Alert.");
    }];
    
    return (NSInteger) PHPhotoLibrary.authorizationStatus;
}

#pragma mark - Public Methods
- (BOOL) granted {
    PHAuthorizationStatus status = PHPhotoLibrary.authorizationStatus;
    return (status == PHAuthorizationStatusAuthorized) || (status == PHAuthorizationStatusRestricted) || (status == PHAuthorizationStatusLimited);
}

- (NSInteger) status {
    return (NSInteger) PHPhotoLibrary.authorizationStatus;
}

- (NSInteger) authorize {
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        return PHAuthorizationStatusAuthorized;
    }
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied) {
        return PHAuthorizationStatusDenied;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                jlog_trace_join(@"Photo Library Access Authorized");
                break;
            case PHAuthorizationStatusDenied:
                jlog_trace_join(@"Photo Library Access Denied");
                break;
            case PHAuthorizationStatusNotDetermined:
                jlog_trace_join(@"Photo Library Access Not Determined");
                break;
            case PHAuthorizationStatusRestricted:
                jlog_trace_join(@"Photo Library Access Restricted");
                break;
            case PHAuthorizationStatusLimited:
                jlog_trace_join(@"Photo Library Access Limited");
                // TODO: PHAuthorizationStatusLimited API_AVAILABLE(ios(14)), // User has authorized this application for limited photo library access. Add PHPhotoLibraryPreventAutomaticLimitedAccessAlert = YES to the application's Info.plist to prevent the automatic alert to update the users limited library selection. Use -[PHPhotoLibrary(PhotosUISupport) presentLimitedLibraryPickerFromViewController:] from PhotosUI/PHPhotoLibrary+PhotosUISupport.h to manually present the limited library picker.
                break;
            default:
                jlog_trace_join(@"Photo Library Access Unknown");
                break;
        }
    }];
    
    return (NSInteger) PHPhotoLibrary.authorizationStatus;
}

@end
