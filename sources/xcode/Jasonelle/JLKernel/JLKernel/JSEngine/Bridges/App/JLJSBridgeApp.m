//
//  JLJSBridgeApp.m
//  JLKernel
//
//  Created by clsource on 15-04-22
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

#import "JLJSBridgeApp.h"

static NSString *BRIDGE_NAME = @"__com_jasonelle_bridges_app";

@implementation JLJSBridgeApp

- (NSString *)globalName {
    return [NSString stringWithFormat:@"%@_global", BRIDGE_NAME];
}

- (void)install {
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Bridge: %@", BRIDGE_NAME]];

    // A global variable that will hold config and other data
    [context eval:[NSString stringWithFormat:@"const %@ = {};", BRIDGE_NAME]];

    // A global variable that will hold polyfills and other data
    [context eval:[NSString stringWithFormat:@"const %@ = {};", self.globalName]];

    [logger trace:@"JS App Bridge Ready" function:@(__FUNCTION__) line:@(__LINE__)];
}

- (void)installGlobalVariables {
    id<JLLoggerProtocol>    logger = self.context.logger;
    JLJSContext *context = self.context;

    [logger trace:[NSString stringWithFormat:@"Installing Global: %@", self.globalName] function:@(__FUNCTION__) line:@(__LINE__)];

    // 1 Get all the global variables inside the global context
    NSDictionary *global = [[context eval:[NSString stringWithFormat:@"%@;", self.globalName] withSourceURLString:self.globalName] toDictionary];

    // 2 For each one create a new constant in the global namespace
    for (id key in global) {
        NSString *variable = [NSString
                              stringWithFormat:@"const %@ = %@['%@'];", key,
                              self.globalName, key];

        [logger trace:[NSString stringWithFormat:@"Adding: %@", variable] function:@(__FUNCTION__) line:@(__LINE__)];

        [context eval:variable
         withSourceURLString:self.globalName];
    }

    [logger trace:@"Global vars added to JSContext" function:@(__FUNCTION__) line:@(__LINE__)];
}

@end
