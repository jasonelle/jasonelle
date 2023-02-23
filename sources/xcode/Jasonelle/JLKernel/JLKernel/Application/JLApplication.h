//
//  JLApplication.h
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

#import <Foundation/Foundation.h>
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLRendererProtocol.h>
#import <JLKernel/JLEnvironment.h>
#import <JLKernel/JLJSContext.h>
#import <JLKernel/JLNotificationCenter.h>
#import <JLKernel/JLJSConfigLoader.h>
#import <JLKernel/JLJSRoutesLoader.h>
#import <JLKernel/JLApplicationEvents.h>
#import <JLKernel/JLApplicationVersion.h>
#import <JLKernel/JLApplicationUtils.h>
#import <JLKernel/JLApplicationExtensions.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/// Main Application Container
NS_SWIFT_NAME(App)
@interface JLApplication : NSObject

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

/// The rendering view created at app boot
@property (nonatomic, strong, nonnull) id<JLRendererProtocol> renderer;

/// The current environment
@property (nonatomic, strong, nonnull) JLEnvironment * env;

/// The root view controller. Normally used for presenting other view controllers.
@property (nonatomic, strong, nullable) UIViewController * rootController;

/// Hooks used inside the webview's main.js. For usage in extensions
@property (nonatomic, strong, nullable) JLJSParams * hooks;

// Maybe this property can be a simple adapter for the real http
//@property (nonatomic, strong, nonnull) JLApplicationHTTP * http;

@property (nonatomic, strong, nonnull) JLJSContext * js;
@property (nonatomic, strong, nonnull) JLJSConfigLoader * config;
@property (nonatomic, strong, nonnull) JLJSRoutesLoader * routes;

@property (nonatomic, strong, nonnull) JLApplicationEvents * events;
@property (nonatomic, strong, nonnull) JLNotificationCenter * notifications;

@property (nonatomic, strong, nonnull) JLApplicationVersion * version;

@property (nonatomic, strong, nonnull) JLApplicationUtils * utils;

@property (nonatomic, strong, nonnull) JLApplicationExtensions * ext;

@property (class) JLApplication * instance;


@end

NS_ASSUME_NONNULL_END
