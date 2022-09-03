//
//  JLExtensions.h
//  JLExtensions
//
//  Created by clsource on 06-05-22
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
#import <JLKernel/JLKernel.h>

// Extensions
#import <JLATTrackingManager/JLATTrackingManager.h>
#import <JLApplicationBadge/JLApplicationBadge.h>

//! Project version number for JLExtensions.
FOUNDATION_EXPORT double JLExtensionsVersionNumber;

//! Project version string for JLExtensions.
FOUNDATION_EXPORT const unsigned char JLExtensionsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JLExtensions/PublicHeader.h>



NS_ASSUME_NONNULL_BEGIN

// This object is accessed using app.ext
@interface JLExtensions : NSObject<JLApplicationExtensionsProtocol>

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) JLApplication * app;

// Extension Classes
@property (nonatomic, strong, nonnull) NSDictionary * classes;

// WebView Message Handlers
@property (nonatomic, strong, nonnull) NSDictionary * handlers;

// Register Class in AppDelegate
- (void) add:(Class)cls;

// Add Extensions for Easier Access
- (nullable JLATTrackingManager *) attracking;
- (JLApplicationBadge *) badge;

/// Call this method on app delegate to configure all extensions
- (instancetype) initWithApp: (JLApplication *) app;
- (BOOL) install;

@end

NS_ASSUME_NONNULL_END
