//
//  JLReachability.m
//  JLReachability
//
//  Created by clsource on 26-02-23.
//
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

#import "JLReachability.h"
#import "JLReachabilityGetMessageHandler.h"

// Official Apple URL for Reachability Check
NSString * const kJLReachabilityHostname = @"www.appleiphonecell.com";
NSString * const kJLReachabilityEvent = @"window.$reachability.events.changed.dispatch";

@implementation JLReachability

- (void) install {
    [super install];
    
    // Listen to Reachability Changes in NSNotificationCenter
    [self.app.events add:[[JLEventReachabilityDidChange alloc] initWithCenter:self.app.notifications andLogger:self.logger]];
    
    // See docs at https://github.com/tonymillion/Reachability
    // Allocate a reachability object
    TonyReachability * reach = [TonyReachability reachabilityForInternetConnection];
    
    jlog_trace_join(@"Reachability Status: ", [reach currentReachabilityString]);
    
    self.status = @([reach currentReachabilityStatus]);
    self.label = [reach currentReachabilityString];
    self.reachable = @([reach isReachable]);
    
    // Set the blocks
    reach.reachableBlock = ^(TonyReachability * reach)
    {
        jlog_trace(@"Reachable?: YES");
        jlog_trace_join(@"Reachability Status: ", [reach currentReachabilityString]);
         
        self.status = @([reach currentReachabilityStatus]);
        self.label = [reach currentReachabilityString];
        self.reachable = @([reach isReachable]);
        
        
        
        // Only triggers the dom events when webview is loaded
        if (!self.webview) {
            return;
        }
        
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.app.utils.webview
             dispatch:kJLReachabilityEvent
             arguments:self.result
             inWebView:self.webview];
        });
    };

    reach.unreachableBlock = ^(TonyReachability * reach)
    {
        jlog_trace(@"Reachable?: NO");
        jlog_trace_join(@"Reachability Status: ", [reach currentReachabilityString]);

        self.status = @(NotReachable);
        self.label = [reach currentReachabilityString];
        self.reachable = @([reach isReachable]);
        
        if (!self.webview) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.app.utils.webview
             dispatch:kJLReachabilityEvent
             arguments:self.result
             inWebView:self.webview];
        });
    };
    
    [reach startNotifier];
    
    self.reach = reach;
    
    self.handlers = @{
        @"$reachability.get": [[JLReachabilityGetMessageHandler alloc] initWithApplication:self.app andExtension:self]
    };
}

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    return [self injectJS];
}

- (NSDictionary *) result {
    return @{
        @"status": self.status,
        @"reachable": self.reachable,
        @"label": self.label
    };
}

@end
