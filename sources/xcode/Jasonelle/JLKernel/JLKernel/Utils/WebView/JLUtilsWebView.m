//
//  JLUtilsWebView.m
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

#import "JLUtilsWebView.h"

@implementation JLUtilsWebView

- (instancetype) initWithLogger:(id<JLLoggerProtocol>)logger andFileSystem: (JLUtilsFileSystem *) fs {
self = [super initWithLogger:logger];
if (self) {
    self.fs = fs;
}
return self;
}

- (WKWebView *) injectIntoWebView: (WKWebView *) webView source: (NSString *) source withInjectionTime: (WKUserScriptInjectionTime) injectionTime forMainFrameOnly: (BOOL) mainFrame {

jlog_trace_join(@"Injecting script into WebView: ", source);

WKUserScript * script = [[WKUserScript alloc] initWithSource:source injectionTime:injectionTime forMainFrameOnly:mainFrame];

[webView.configuration.userContentController addUserScript: script];

return webView;
}

- (WKWebView *) injectIntoWebView: (WKWebView *) webView source: (NSString *) source {
return [self injectIntoWebView:webView source:source withInjectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
}

- (WKWebView *) inject: (NSString *) file intoWebView: (WKWebView *) webView for: (id) object {
    
    NSString * js = [self.fs
         readJS:file
         for:object];
    
    return [self injectIntoWebView:webView source:js];
}

- (WKWebView *) inject: (id) object intoWebView: (WKWebView *) webView {
    NSString * js = [self.fs readJSFor:object];
    return [self injectIntoWebView:webView source:js];
}

@end
