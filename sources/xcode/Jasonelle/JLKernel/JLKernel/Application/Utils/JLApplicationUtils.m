//
//  JLApplicationUtils.m
//  JLKernel
//
//  Created by clsource on 05-05-22
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

#import "JLApplicationUtils.h"

@implementation JLApplicationUtils

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger andRootController:(nonnull UIViewController *)rootController {
    self = [super init];

    if (self) {
        self.logger = logger;
        self.rootController = rootController;
    }

    return self;
}

- (NSString *)uuid {
    return [[NSUUID UUID] UUIDString];
}

- (JLUtilsBase64 *)base64 {
    if (!_base64) {
        _base64 = [[JLUtilsBase64 alloc] initWithLogger:self.logger];
    }

    return _base64;
}

- (JLUtilsJSON *)json {
    if (!_json) {
        _json = [[JLUtilsJSON alloc] initWithLogger:self.logger];
    }

    return _json;
}

- (JLUtilsFileSystem *)fs {
    if (!_fs) {
        _fs = [[JLUtilsFileSystem alloc] initWithLogger:self.logger];
    }

    return _fs;
}

- (JLUtilsWebView *) webview {
    if (!_webview) {
        _webview = [[JLUtilsWebView alloc] initWithLogger:self.logger json: self.json andFileSystem:self.fs];
    }
    return _webview;
}

- (JLUtilsClipboard *) clipboard {
    if (!_clipboard) {
        _clipboard = [[JLUtilsClipboard alloc] initWithLogger:self.logger];
    }
    return _clipboard;
}

- (BOOL) openURL: (NSString *) urlString {
    NSURL * url = [NSURL URLWithString:urlString];
    jlog_trace_join(@"Openning URL: ", url.absoluteString);
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            jlog_trace_join(@"Was Open?: ", jlog_b2s(success));
        }];
        return YES;
    }
    jlog_trace(@"Could not open URL");
    return NO;
}

- (void) openSafariWithURL:( NSURL * __nonnull ) url
                  delegate: (id<SFSafariViewControllerDelegate> __nullable) delegate
             configuration:(SFSafariViewControllerConfiguration * __nullable)configuration
                completion:(void (^ __nullable)(void))completion {
    
    jlog_trace(@"Creating Safari Controller");
    
    SFSafariViewController * safari = [[SFSafariViewController alloc] initWithURL:url];
    
    if(configuration) {
        safari = [[SFSafariViewController alloc] initWithURL:url configuration:configuration];
    }
    
    safari.delegate = delegate;
    
    jlog_trace_join(@"Presenting Safari Controller for URL", url.absoluteString);
    
    if(!completion) {
        completion = ^{
            jlog_trace_join(@"Presented Safari for URL: ", url.absoluteString);
        };
    }
    
    [self present:safari completion:completion];
}

- (void) openSafariWithURL:( NSURL * __nonnull ) url configuration:(SFSafariViewControllerConfiguration * __nullable)configuration {
    return [self openSafariWithURL:url delegate:nil configuration:configuration completion:nil];
}

- (void) openSafariWithURL:( NSURL * __nonnull ) url {
    return [self openSafariWithURL:url delegate:nil configuration:nil completion:nil];
}

- (NSURL *) settingsURL {
    return [NSURL URLWithString:UIApplicationOpenSettingsURLString];
}

- (void) openSettings {
    [self openURL:UIApplicationOpenSettingsURLString];
}

- (void) present:(UIViewController *)controller completion:(void (^ __nullable)(void))completion {
    // Since we must show something is required to do it in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rootController
         presentViewController:controller
         animated:YES
         completion:completion];
    });
}
@end
