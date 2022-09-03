//
//  JLJSContext.h
//  JLKernel
//
//  Created by clsource on 14-04-22
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
