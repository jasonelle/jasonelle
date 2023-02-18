//
//  JLEventDidReceiveOpenURL.m
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

#import "JLEventDidReceiveOpenURL.h"

@implementation JLEventDidReceiveOpenURL

- (void)triggerWithURL:(NSURL *)url andOptions:(NSDictionary *)options {
    
    NSString * urlString = [url absoluteString];
    
    BOOL isOAuth = [urlString containsString:@"://oauth"];
    BOOL isHref = [urlString containsString:@"://href"];
    BOOL isJSON = [urlString containsString:@"://json"];

    NSString *type = @"unknown";

    if (isOAuth) {
        type = @"oauth";
    }

    // example: "jasonelle://href?=https://ninjas.cl"
    if (isHref) {
        type = @"href";
    }

    // example: "jasonelle://json?=%7B%22hello%22%3A%20%22world%22%7D"
    if (isJSON) {
        type = @"json";
    }
    
    if ([type isEqualToString:@"unknown"]) {
        jlog_warning_join(@"Unknown type for open url: ", urlString);
    }
    
    NSURLComponents * components = [[NSURLComponents alloc] initWithString:urlString];
    
    NSString * value = components.queryItems.firstObject.value;
    value = (value ? value : @"");

    NSDictionary *params = @{
        @"url": urlString,
        @"options": options,
        @"value": value,
        @"type": type
    };

    jlog_trace_join(@"App Did Open URL: ", params);

    [self triggerWithParams:params];
}

- (void)triggerWithURL:(NSURL *)url {
    [self triggerWithURL:url andOptions:@{}];
}

@end
