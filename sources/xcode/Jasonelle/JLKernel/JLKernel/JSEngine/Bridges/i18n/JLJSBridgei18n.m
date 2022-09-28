//
//  JLJSBridgei18n.m
//  JLKernel
//
//  Created by clsource on 30-04-22
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

#import "JLJSBridgei18n.h"
#import <JLKernel/JLJSParams.h>

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_i18n";

@implementation JLJSBridgei18n

- (void)install {
    // It's important to not use self or weakSelf
    // inside the context's binding
    // because the weakself it will be erased
    // since the install method is not retained
    // after use inside AppDelegate
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Bridge: %@", BRIDGE_NAME]];

    // Returns a localized version of the string designated by the specified key and residing in the specified table.
    // see: https://developer.apple.com/documentation/foundation/nsbundle/1417694-localizedstringforkey
    context.context[BRIDGE_NAME] = ^(NSDictionary *argv) {
        JLJSParams *params = [[JLJSParams alloc] initWithDictionary:argv];

        NSString *key = [params string:@"key" default:@""];
        NSString *value = [params string:@"value" default:@""];
        NSString *table = [params string:@"table"];
        NSString *bundleIdentifier = [params string:@"bundle"];

        NSBundle *bundle = [NSBundle mainBundle];

        if (bundleIdentifier) {
            bundle = [NSBundle bundleWithIdentifier:bundleIdentifier];

            if (!bundle) {
                bundle = [NSBundle mainBundle];
            }
        }

        return [bundle localizedStringForKey:key value:value table:table];
    };

    [logger trace:@"JS i18n Bridge Ready" function:@(__FUNCTION__) line:@(__LINE__)];
}

@end
