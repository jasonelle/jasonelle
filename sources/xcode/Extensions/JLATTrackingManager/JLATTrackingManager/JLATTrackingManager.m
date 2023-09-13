//
//  JLATTrackingManager.m
//
//  Created by clsource on 24-04-22
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


#import <JLATTrackingManager/JLATTrackingManager.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import "JLATTrackingManagerStatusHandler.h"

@implementation JLATTrackingManager

- (NSNumber *) status {
    if (!_status) {
        _status = @(ATTrackingManagerAuthorizationStatusDenied);
    }
    return _status;
}

- (void) install {
    [super install];
    
    JLATTrackingManagerStatusHandler * handler = [[JLATTrackingManagerStatusHandler alloc] initWithApplication:self.app andExtension:self];
    
    self.handlers = @{
        @"$attracking.status": handler,
    };
    
    [self startATTracking];
}

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    
    return [self.app.utils.webview inject:self intoWebView:webView];
}

#pragma mark - Helpers
- (void) startATTracking {
    // TODO: Check if plist is set and throw error or trace
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            self.status = @(status);
            jlog_trace_join(@"ATTracking status: ", [self stringForStatus:status], @" - ", self.status.description);
        }];
    } else {
        jlog_trace(@"ATTracking Not Available");
    }
}

- (NSString *) stringForStatus: (NSInteger) status {
    return (status == ATTrackingManagerAuthorizationStatusAuthorized ? @"Authorized" : @"Denied");
}
@end
