//
//  JLStreamLogHandler.m
//  JLKernel
//
//  Created by clsource on 02-02-22
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
