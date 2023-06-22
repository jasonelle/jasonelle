//
//  JLApplicationUtils.h
//  JLKernel
//
//  Created by clsource on 05-05-22
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
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLUtilsBase64.h>
#import <JLKernel/JLUtilsJSON.h>
#import <JLKernel/JLUtilsFileSystem.h>
#import <JLKernel/JLUtilsWebView.h>
#import <JLKernel/JLUtilsClipboard.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationUtils : NSObject

#pragma mark - Properties

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

@property (nonatomic, strong, nonnull) JLUtilsBase64 * base64;
@property (nonatomic, strong, nonnull) JLUtilsJSON * json;
@property (nonatomic, strong, nonnull, readonly) NSString * uuid;
@property (nonatomic, strong, nonnull) JLUtilsFileSystem * fs;
@property (nonatomic, strong, nonnull) JLUtilsWebView * webview;
@property (nonatomic, strong, nonnull) JLUtilsClipboard * clipboard;

@property (nonatomic, strong, nonnull) UIViewController * rootController;

#pragma mark - Init Methods
- (instancetype) initWithLogger: (id<JLLoggerProtocol>) logger andRootController:(UIViewController *) rootController;

#pragma mark - Helper Methods

// If there are more than 1 helper method in the same context, is best to move it to a separate class and have a property here
- (BOOL) openURL: (NSString *) urlString;

/// UIApplicationOpenSettingsURLString
- (NSURL *) settingsURL;
- (void) openSettings;

- (void) present: (UIViewController *) controller completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
