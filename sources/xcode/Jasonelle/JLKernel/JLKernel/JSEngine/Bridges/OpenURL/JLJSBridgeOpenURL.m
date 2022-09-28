//
//  JLJSBridgeOpenURL.m
//  JLKernel
//
//  Created by clsource on 01-05-22
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

#import "JLJSBridgeOpenURL.h"
#import <JLKernel/JLJSParams.h>
#import <UIKit/UIKit.h>

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_openurl";

@implementation JLJSBridgeOpenURL

- (void)install {
    // It's important to not use self or weakSelf
    // inside the context's binding
    // because the weakself it will be erased
    // since the install method is not retained
    // after use inside AppDelegate
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Bridge: %@", BRIDGE_NAME]];

    /// Use this method to open the specified resource. If the specified URL scheme is handled by another app, iOS launches that app and passes the URL to it. (Launching the app brings the other app to the foreground.) If no app is capable of handling the specified scheme, the completion handler is called with the success parameter set to NO.
    /// The URL can have a common scheme such as http, https, tel, or facetime, or a custom scheme. For information about supported schemes, see Apple URL Scheme Reference.
    /// see: https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl?language=objc
    /// see: https://developer.apple.com/documentation/uikit/uiapplication/1648685-openurl?language=objc
    context.context[BRIDGE_NAME] = ^(NSDictionary *argv) {
        JLJSParams *params = [[JLJSParams alloc] initWithDictionary:argv];

        // TODO: Check if this is correctly encoded
        // https://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
        NSString *location = [[params string:@"url" default:@""] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url = [NSURL URLWithString:location];

        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                [logger trace:[NSString stringWithFormat:@"Open URL (%@): %@", (success ? @"success" : @"fail"), url] function:@(__FUNCTION__) line:@(__LINE__)];
            }];
        }
        else {
            [logger trace:[NSString stringWithFormat:@"Can't Open URL: %@", url] function:@(__FUNCTION__) line:@(__LINE__)];
        }
    };

    [logger trace:@"JS URLOpen Bridge Ready" function:@(__FUNCTION__) line:@(__LINE__)];
}

@end
