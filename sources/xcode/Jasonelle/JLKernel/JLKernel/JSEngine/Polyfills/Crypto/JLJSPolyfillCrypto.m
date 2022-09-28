//
//  JLJSPolyfillCrypto.m
//  JLKernel
//
//  Created by clsource on 21-04-22
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

#import "JLJSPolyfillCrypto.h"

static NSString *POLYFILL_NAME = @"__com_jasonelle_polyfills_crypto_get_random_values";

@implementation JLJSPolyfillCrypto

- (void)install {
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Polyfill: %@", POLYFILL_NAME]];

    context.context[POLYFILL_NAME] = ^(NSNumber *bytes) {
        // Extracted from https://raw.githubusercontent.com/LinusU/react-native-get-random-values/master/ios/RNGetRandomValues.m

        NSUInteger byteLength = [bytes unsignedIntegerValue];
        NSMutableData *data = [NSMutableData dataWithLength:byteLength];

        int result = SecRandomCopyBytes(kSecRandomDefault, byteLength, data.mutableBytes);

        if (result != errSecSuccess) {
            @throw([NSException exceptionWithName:@"NO_RANDOM_BYTES" reason:@"Failed to aquire secure random bytes" userInfo:nil]);
        }

        NSString *base64 = [data base64EncodedStringWithOptions:kNilOptions];
        return base64;
    };

    // Load the JS file
    [context evalJSFile:@"JLJSPolyfillCrypto"
                    for:self];

    if (context.context.exception) {
        NSString *message = [NSString stringWithFormat:@"JS Polyfill Exception: %@.", context.context.exception.debugDescription];

        NSException *ex = [NSException exceptionWithName:@"com.jasonelle.runtime.exception" reason:message userInfo:@{ @"exception": context.context.exception }];

        [ex raise];
    }

    [context.logger trace:@"JS Crypto Polyfill Ready"
                 function:@(__FUNCTION__)
                     line:@(__LINE__)];
}

@end
