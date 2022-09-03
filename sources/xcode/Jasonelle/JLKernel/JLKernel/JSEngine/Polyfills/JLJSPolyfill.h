//
//  JLJSPolyfill.h
//  JLKernel
//
//  Created by clsource on 21-04-22
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
#import <JLKernel/JLJSContext.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLJSPolyfillProtocol <NSObject>

- (void) install;
+ (id<JLJSPolyfillProtocol>) installInContext: (JLJSContext *) context;

@end

/// Polyfill with native functions things that are not available in JSContexts
@interface JLJSPolyfill : NSObject<JLJSPolyfillProtocol>

@property (nonatomic, strong, nonnull) JLJSContext * context;

- (instancetype) initWithContext: (JLJSContext *) context;

@end

NS_ASSUME_NONNULL_END
