//
//  JLEventDidReceiveOpenURL.m
//  JLKernel
//
//  Created by clsource on 01-05-22
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

#import "JLEventDidReceiveOpenURL.h"

@implementation JLEventDidReceiveOpenURL

- (void)triggerWithURL:(NSURL *)url andOptions:(NSDictionary *)options {
    BOOL isOAuth = [[url absoluteString] containsString:@"://oauth"];
    BOOL isHref = [[url absoluteString] containsString:@"://href?"];
    BOOL isJSON = [[url absoluteString] containsString:@"://json?"];

    NSString *type = @"unknown";

    if (isOAuth) {
        type = @"oauth";
    }

    if (isHref) {
        type = @"href";
    }

    if (isJSON) {
        type = @"json";
    }

    NSDictionary *params = @{
        @"url": [url absoluteString],
        @"options": options,
        @"type": type
    };

    jlog_trace_join(@"App Did Open URL: ", params);

    [self triggerWithParams:params];
}

@end
