//
//  JLEventReachabilityDidChange.m
//  JLKernel
//
//  Created by clsource on 01-03-23.
//  Copyright © Jasonelle.com. All rights reserved.
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

#import "JLEventReachabilityDidChange.h"

@implementation JLEventReachabilityDidChange

- (void)install {
    [super install];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(onEvent:)
            name:@"kReachabilityChangedNotification"
          object:nil];
}

- (void)uninstall {
    [super uninstall];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)notification {
    
    
    id<JLReachabilityNotificationObject> reach = notification.object;
    
    NSDictionary * params = @{
        @"status": @([reach currentReachabilityStatus]),
        @"label": [reach currentReachabilityString],
        @"reachable": @([reach isReachable])
    };

    jlog_trace(@"App Did Change Reachability");
    jlog_trace(params.description);

    [self triggerWithParams:params];
}

- (void) triggerNoConnectionEvent {
    NSDictionary * params = @{
        @"status": @0,
        @"label": @"No Connection",
        @"reachable": @NO
    };
    
    jlog_trace(@"App Did Change Reachability (No Connection)");
    [self triggerWithParams:params];
}

@end
