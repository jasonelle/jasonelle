//
//  JLJSPolyfillCrypto.m
//  JLKernel
//
//  Created by clsource on 21-04-22
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
