//
//  JLJSLoggerMessageHandler.m
//  JLKernel
//
//  Created by clsource on 15-05-22
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


#import "JLJSLoggerMessageHandler.h"
#import <JLKernel/JLJSParams.h>

@implementation JLJSLoggerMessageHandler

- (void)handleWithOptions:(NSDictionary *)options {
    [super handleWithOptions:options];

    JLJSParams *params = [[JLJSParams alloc] initWithDictionary:options];

    NSString *message = [params string:@"message"];
    JLJSParams *opts = [params get:@"options"];

    NSDictionary *metadata = [opts dictionary:@"meta"];

    NSNumber *line = [opts number:@"line"];
    NSString *file = [opts string:@"file"];
    NSString *func = [opts string:@"func"];

    NSString *source = [opts string:@"source"];

    NSString *levelString = [opts string:@"level"];

    JLLogLevel *level = [JLLogLevelFactory for:levelString];

    [self.logger log:level message:message metadata:metadata source:source file:file function:func line:line];

    // Ensure to call self.resolve or self.reject
    self.resolve(options);
}

@end
