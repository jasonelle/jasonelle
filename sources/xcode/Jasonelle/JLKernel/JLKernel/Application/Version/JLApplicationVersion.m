//
//  JLApplicationVersion.m
//  JLKernel
//
//  Created by clsource on 04-05-22
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
