//
//  JLJSRoutesLoader.m
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

#import "JLJSRoutesLoader.h"

static NSString *OBJ_NAME = @"__com_jasonelle_bridges_app.Router";

@implementation JLJSRoutesLoader

- (instancetype)initWithContext:(JLJSContext *)context {
    self = [super init];

    if (self) {
        self.context = context;
        self.logger = context.logger;
    }

    return self;
}

- (nonnull JLJSValue *)value {
    // Return the variable that holds the config object

    // Path must not have ; at the end so we can concatenate it later
    NSString *path = [NSString stringWithFormat:@"%@", OBJ_NAME];

    JLJSValue *val = [self.context eval:[NSString stringWithFormat:@"%@;", path] withSourceURLString:@"file://com.jasonelle.js.kernel.routes"];

    val.path = path;
    return val;
}

- (nonnull JLJSRoutes *)load {
    JLJSValue *value = [self value];

    NSDictionary *dictionary = [value toDictionary];

    if (!dictionary) {
        NSString *message = @"JS Routes Object not found. "                       \
            @"Be sure to set __com_jasonelle_bridges_app.Router " \
            @"inside _build/app.js";

        [self.logger critical:message];

        NSException *ex = [NSException exceptionWithName:@"com.jasonelle.runtime.exception" reason:message userInfo:nil];

        [ex raise];
    }

    return [[JLJSRoutes alloc]
            initWithDictionary:dictionary
                       context:self.context
                      andValue:value];
}

@end
