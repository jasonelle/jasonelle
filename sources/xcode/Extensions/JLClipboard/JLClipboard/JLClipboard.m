//
//  JLDevice.m
//  JLDevice
//
//  Created by clsource on 22-06-23.
//  Copyright (c) Jasonelle.com
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

#import "JLClipboard.h"
#import "JLClipboardSetHandler.h"
#import "JLClipboardGetHandler.h"

@implementation JLClipboard

- (void) install {
    [super install];
    
    JLClipboardSetHandler * handlerSet = [[JLClipboardSetHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLClipboardGetHandler * handlerGet = [[JLClipboardGetHandler alloc] initWithApplication:self.app andExtension:self];
    
    self.handlers = @{
        @"$clipboard.set" : handlerSet,
        @"$clipboard.get" : handlerGet
    };
}

#pragma mark - Extension Public Methods

#pragma mark - WebView Injection
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    return [self injectJS];
}

@end
