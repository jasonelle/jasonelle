//
//  JLApplication.h
//  JLKernel
//
//  Created by clsource on 03-02-22
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

NS_ASSUME_NONNULL_BEGIN

/// Main Application Container
NS_SWIFT_NAME(App)
@interface JLApplication : NSObject

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

/// The rendering view created at app boot
@property (nonatomic, strong, nonnull) id<JLRendererProtocol> renderer;

@property (nonatomic, strong, nonnull) JLEnvironment * env;

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
