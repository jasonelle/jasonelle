//
//  JLApplicationVersion.m
//  JLKernel
//
//  Created by clsource on 04-05-22
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

#import "JLApplicationVersion.h"

@implementation JLApplicationVersion

- (NSString *)string {
    if (!_string) {
        _string = @(JASONELLE_VERSION_STRING);
    }

    return _string;
}

- (NSNumber *)number {
    if (!_number) {
        _number = @(JASONELLE_VERSION_NUMBER);
    }

    return _number;
}

- (NSDictionary *)dictionary {
    if (!_dictionary) {
        _dictionary = @{
            @"major": @(JASONELLE_VERSION_MAJOR),
            @"minor": @(JASONELLE_VERSION_MINOR),
            @"patch": @(JASONELLE_VERSION_PATCH),
            @"string": self.string,
            @"number": self.number
        };
    }

    return _dictionary;
}

- (BOOL)atLeast:(int)major minor:(int)minor patch:(int)patch {
    if (major > JASONELLE_VERSION_MAJOR) {
        return NO;
    }

    if (major < JASONELLE_VERSION_MAJOR) {
        return YES;
    }

    if (minor > JASONELLE_VERSION_MINOR) {
        return NO;
    }

    if (minor < JASONELLE_VERSION_MINOR) {
        return YES;
    }

    if (patch > JASONELLE_VERSION_PATCH) {
        return NO;
    }

    if (patch < JASONELLE_VERSION_PATCH) {
        return YES;
    }

    return YES;
}

- (BOOL)atLeast:(int)major {
    return [self atLeast:major minor:0 patch:0];
}

@end
