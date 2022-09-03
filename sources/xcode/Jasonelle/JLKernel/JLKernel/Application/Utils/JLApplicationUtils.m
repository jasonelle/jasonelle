//
//  JLApplicationUtils.m
//  JLKernel
//
//  Created by clsource on 05-05-22
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

#import "JLApplicationUtils.h"

@implementation JLApplicationUtils

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];

    if (self) {
        self.logger = logger;
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

@end
