//
//  JLOneSignalGetInfoHandler.m
//  JLOneSignalGetInfoHandler
//
//  Created by clsource on 20-09-23.
//  Copyright (c) Jasonelle.com
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

#import "JLOneSignalGetInfoHandler.h"
#import <OneSignalFramework/OneSignalFramework.h>

@implementation JLOneSignalGetInfoHandler

- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    NSDictionary * state = [self getOneSignalState];
    
    jlog_trace(state.description);
    
    self.resolve(state);
}

- (NSDictionary *) getOneSignalState {
    
    // https://documentation.onesignal.com/docs/device-user-model-mobile-sdk-mapping#mobile-sdk-mapping
    
    NSMutableDictionary * state = [@{} mutableCopy];
    
    [state setObject:OneSignal.sdkSemanticVersion forKey:@"version"];
    
    NSString * pushId = OneSignal.User.pushSubscription.id;
    [state setObject:[NSNull null] forKey:@"pushId"];
    if (pushId) {
        [state setObject:pushId forKey:@"pushId"];
    } else {
        jlog_warning(@"OneSignal userId is null. Please check your OneSignal integration and configuration.");
    }
    
    NSString * token = OneSignal.User.pushSubscription.token;
    [state setObject:[NSNull null] forKey:@"token"];
    if (token) {
        [state setObject:token forKey:@"token"];
    } else {
        jlog_warning(@"Push notification token is null. Please check your OneSignal integration and configuration.");
    }
    
    
    [state setObject:@([OneSignal.Notifications permissionNative]) forKey:@"status"];
    [state setObject:@(OneSignal.User.pushSubscription.optedIn) forKey:@"optedIn"];
    
    NSString * onesignalId = OneSignal.User.onesignalId;
    [state setObject:[NSNull null] forKey:@"onesignalId"];
    if (onesignalId) {
        [state setObject:onesignalId forKey:@"onesignalId"];
    }
    
    NSString * externalId = OneSignal.User.externalId;
    [state setObject:[NSNull null] forKey:@"externalId"];
    if (externalId) {
        [state setObject:externalId forKey:@"externalId"];
    }
    
    
    
    jlog_debug([state description]);
    
    return [state copy];
}

@end
