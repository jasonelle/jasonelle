//
//  JLJSContext.m
//  JLKernel
//
//  Created by clsource on 14-04-22
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

#import "JLJSContext.h"

static NSString *defaultSourceURLString = @"file://com.jasonelle.kernel.js.context";

@implementation JLJSContext

- (instancetype)initWithContext:(JSContext *)context andLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.context = context;
        self.logger = logger;
    }
    return self;
}

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger
                  andSourceURL:(nullable NSString *)sourceURL {

    self = [self initWithContext:[JSContext new] andLogger:logger];

    if (self) {
        self.sourceURL = [NSURL URLWithString:defaultSourceURLString];

        if (sourceURL) {
            self.sourceURL = [NSURL URLWithString:sourceURL];
        }

        [self.context setExceptionHandler:^(JSContext *context, JSValue *exception) {
            [logger warning:@"JS Eval Failed"];

            NSString *stack = [[exception objectForKeyedSubscript:@"stack"] toString];
            NSNumber *line = [[exception objectForKeyedSubscript:@"line"] toNumber];
            NSNumber *column = [[exception objectForKeyedSubscript:@"column"] toNumber];

            // TODO: Check if we can get the source URL
            [logger trace:[NSString stringWithFormat:@"exception: %@ | stack: %@ | line: %@ | col: %@ | context: %@", exception.debugDescription, stack, line, column, (sourceURL ? sourceURL : defaultSourceURLString)] file:@(__FILE__).lastPathComponent function:@(__FUNCTION__) line:@(__LINE__)];

            // Store the exception so it can be handled in other areas
            context.exception = exception;
        }];
    }

    return self;
}

// TODO: add webview context extractor utility?
//       JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

- (JLJSValue *)eval:(NSString *)content withSourceURLString:(NSString *)urlString {
    JLJSValue *val = [[JLJSValue alloc]
                      initWithValue:[self.context
                                     evaluateScript:content
                                      withSourceURL:[NSURL URLWithString:urlString]]];

    return val;
}

- (JLJSValue *)eval:(NSString *)content {
    return [self eval:content withSourceURLString:self.sourceURL.absoluteString];
}

- (JLJSValue *)evalFile:(NSString *)file
          withExtension:(NSString *)ext
               inBundle:(NSBundle *)bundle {
    NSString *filename = [NSString
                          stringWithFormat:@"%@.%@", file, ext];

    NSString *path = [bundle
                      pathForResource:file
                               ofType:ext];

    if (!path) {
        jlog_warning_join(@"Path is empty for file ", filename);
    }

    jlog_trace_fmt(@"Loading File: %@, Path: %@", filename, path);

    NSError *error;

    NSString *script = [NSString
                        stringWithContentsOfFile:path
                                        encoding:NSUTF8StringEncoding
                                           error:&error];

    if ([[script stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        jlog_notice_join(filename, @" is empty");
    }

    if (error) {
        jlog_error(error.description);
    }

    return [self eval:script withSourceURLString:filename];
}

- (JLJSValue *)evalJSFile:(NSString *)file inBundle:(NSBundle *)bundle {
    return [self evalFile:file withExtension:@"js" inBundle:bundle];
}

- (JLJSValue *)evalJSFile:(NSString *)file {
    return [self evalJSFile:file inBundle:[NSBundle mainBundle]];
}

- (JLJSValue *)evalJSFile:(NSString *)file for:(id)object {
    return [self evalJSFile:file inBundle:[NSBundle bundleForClass:[object class]]];
}

@end
