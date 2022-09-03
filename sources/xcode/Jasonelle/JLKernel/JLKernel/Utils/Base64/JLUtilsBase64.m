//
//  JLUtilsBase64.m
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

#import "JLUtilsBase64.h"

@implementation JLUtilsBase64

- (NSString *)encode:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [data base64EncodedStringWithOptions:kNilOptions];

    return encoded;
}

- (NSString *)decode:(NSString *)encoded {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encoded options:kNilOptions];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
