//
//  AppExtensions.m
//  App
//
//  Created by clsource on 17-02-23.
//  Copyright (c) 2023 Jasonelle.com
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

#import "AppExtensions.h"

// First add the framework in the App.xcodeproj file then
// Add or uncomment and configure the extensions here.
// See more at https://jasonelle.com/docs/xcode/Extensions.html
//
#import <JLATTrackingManager/JLATTrackingManager.h>
#import <JLApplicationBadge/JLApplicationBadge.h>
#import <JLPhotoLibrary/JLPhotoLibrary.h>
#import <JLKeychain/JLKeychain.h>
#import <JLCookies/JLCookies.h>
#import <JLContacts/JLContacts.h>
#import <JLReachability/JLReachability.h>
#import <JLAudio/JLAudio.h>
#import <JLDevice/JLDevice.h>
#import <JLClipboard/JLClipboard.h>
#import <JLToast/JLToast.h>
#import <JLShare/JLShare.h>

#import <MyExtension/MyExtension.h> // Example Extension

@implementation AppExtensions

- (instancetype) initWithApp: (JLApplication *) app {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
        self.extensions = [[JLExtensions alloc] initWithApp:app];
    }
    return self;
}

#pragma mark - Configure Your Extensions

- (BOOL) install {
//     Setup ATTracking Manager
    [self.extensions add:JLATTrackingManager.class];

//     Setup permissions in info.plist to access photos
    [self.extensions add:JLPhotoLibrary.class];

//     Add $badge extension
    [self.extensions add:JLApplicationBadge.class];

//     Add $keychain extension
    [self.extensions add:JLKeychain.class];

//     Add $cookies extension
    [self.extensions add:JLCookies.class];

//     Add $contacts extension
    [self.extensions add:JLContacts.class];
    
//     Add $reachability extension
    [self.extensions add:JLReachability.class];

//    Add $audio extension
    [self.extensions add:JLAudio.class];
    
//    Add $device extension
    [self.extensions add:JLDevice.class];
    
//    Add $clipboard extension
    [self.extensions add:JLClipboard.class];
    
//    Add $toast extension
    [self.extensions add:JLToast.class];
    
//    Add $share extension
    [self.extensions add:JLShare.class];
    
//    Add Example Extension
    [self.extensions add:MyExtension.class];
    
//    Install all the extensions
    return [self.extensions install];
}

- (BOOL) application:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    return [self install] && [self.extensions application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
