//
//  JLUtilsWebView.h
//  JLKernel
//
//  Created by clsource on 19-02-23.
//  Copyright © 2023 Jasonelle.com. All rights reserved.
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


#import <JLKernel/JLUtil.h>
#import <JLKernel/JLUtilsFileSystem.h>
#import <JLKernel/JLUtilsJSON.h>

@import WebKit;

NS_ASSUME_NONNULL_BEGIN


@interface JLUtilsWebView : JLUtil

@property (nonatomic, strong, nonnull) JLUtilsFileSystem * fs;
@property (nonatomic, strong, nonnull) JLUtilsJSON * json;

- (instancetype) initWithLogger:(id<JLLoggerProtocol>)logger
                           json: (JLUtilsJSON *) json
                  andFileSystem: (JLUtilsFileSystem *) fs;

/// Injects a string to the webview.
- (WKWebView *) injectIntoWebView: (WKWebView *) webView source: (NSString *) source withInjectionTime: (WKUserScriptInjectionTime) injectionTime forMainFrameOnly: (BOOL) mainFrame;

/// Injects a string to the webview. Using Mainframe with Done injection time.
- (WKWebView *) injectIntoWebView: (WKWebView *) webView source: (NSString *) source;

/// Reads the file content inside the object's bundle and inject it to the webview. Using Mainframe with Done injection time.
- (WKWebView *) inject: (NSString *) file intoWebView: (WKWebView *) webView for: (id) object;

/// Reads the "(Object.class)".js file and inject it to the webview. Using Mainframe with Done injection time.
- (WKWebView *) inject: (id) object intoWebView: (WKWebView *) webView;

/// Dispatch an event
- (WKWebView *) dispatch: (NSString *) event arguments: (NSDictionary<NSString*, id> *) arguments inWebView: (WKWebView *) webView;
@end

NS_ASSUME_NONNULL_END
