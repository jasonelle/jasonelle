//
//  JLJSContext.h
//  JLKernel
//
//  Created by clsource on 14-04-22
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
#import <JavaScriptCore/JavaScriptCore.h>
#import <JLKernel/JLLoggerProtocol.h>
#import <JLKernel/JLJSValue.h>
#import <JLKernel/JLJSMessageHandlers.h>

NS_ASSUME_NONNULL_BEGIN

@class JLApplication;

/// This file helps with JSContext
@interface JLJSContext : NSObject

@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) JSContext * context;
@property (nonatomic, strong, nonnull) NSURL * sourceURL;
@property (nonatomic, strong, nonnull) JSValue * exception;
@property (nonatomic, strong, nonnull) JLJSMessageHandlers * handlers;

- (instancetype) initWithContext: (JSContext *) context andLogger:(id<JLLoggerProtocol>)logger;

- (instancetype) initWithLogger: (id<JLLoggerProtocol>) logger andSourceURL: (nullable NSString *) sourceURL;

/// Evaluates a JS String inside context
- (JLJSValue *) eval: (NSString *) content;
- (JLJSValue *) eval: (NSString *) content withSourceURLString: (NSString *) urlString;

/// Loads a file from main bundle
/// and returns it's JSValue
- (JLJSValue *) evalFile: (NSString *) file
          withExtension: (NSString *) ext
                inBundle: (NSBundle *) bundle;

/// Loads a JS file from main bundle
/// and returns it's JSValue
/// defaults to mainBundle
- (JLJSValue *) evalJSFile: (NSString *) file;

- (JLJSValue *) evalJSFile: (NSString *) file inBundle: (NSBundle *) bundle;

// Determines the bundle for the object and loads the js
- (JLJSValue *) evalJSFile: (NSString *) file for: (id) object;

@end

NS_ASSUME_NONNULL_END
