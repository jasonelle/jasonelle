//
//  JLStreamLogHandler.m
//  JLKernel
//
//  Created by clsource on 02-02-22
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

#import "JLStreamLogHandler.h"

@implementation JLStreamLogHandler

@synthesize level;
@synthesize metadata;

- (instancetype)initWithLabel:(nonnull NSString *)label andStream:(JLStream)stream {
    self.label = label;
    self.stream = stream;
    return self;
}

- (nonnull instancetype)initWithLabel:(nonnull NSString *)label andLevel:(nonnull JLLogLevel *)level {
    JLStreamLogHandler *handler = [JLStreamLogHandler standardOutput:label];

    handler.level = level;
    return handler;
}

+ (instancetype)standardOutput:(nonnull NSString *)label {
    return [[JLStreamLogHandler alloc] initWithLabel:label andStream:JLStreamStdio];
}

+ (instancetype)standardError:(nonnull NSString *)label {
    return [[JLStreamLogHandler alloc] initWithLabel:label andStream:JLStreamStderr];
}

- (nullable NSString *)log:(nonnull JLLogLevel *)level message:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    NSMutableString *output = [[NSString stringWithFormat:@"%@: [%@] %@", self.label, [level.label uppercaseString], message] mutableCopy];

    if (source) {
        [output appendFormat:@" | source: %@", source];
    }

    if (file) {
        [output appendFormat:@" | file: %@", file];
    }

    if (func) {
        [output appendFormat:@" | function: %@", func];
    }

    if (line) {
        [output appendFormat:@" | line: %@", line];
    }

    if (metadata) {
        [output appendFormat:@" | %@", metadata];
    }

    if (self.stream == JLStreamStdio) {
        fprintf(stdout, "%s\n", [output UTF8String]);
    }
    else {
        fprintf(stderr, "%s\n", [output UTF8String]);
    }

    return output;
}

@end
