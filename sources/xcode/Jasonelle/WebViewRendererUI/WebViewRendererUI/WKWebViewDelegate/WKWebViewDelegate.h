//
//  WKWebViewDelegate.h
//  WebViewRendererUI
//
//  Created by clsource on 13-05-22
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

@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewDelegate : NSObject<WKNavigationDelegate, WKScriptMessageHandlerWithReply>

@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;
@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) NSString * identifier;

- (instancetype) initWithIdentifier: (NSString *) identifier;
- (instancetype) initWithApp: (JLApplication *) app andIdentifier: (NSString *) identifier;


@end

NS_ASSUME_NONNULL_END
