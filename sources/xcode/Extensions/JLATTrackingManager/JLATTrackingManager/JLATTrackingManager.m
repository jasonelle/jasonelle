//
//  JLATTrackingManager.m
//
//  Created by clsource on 24-04-22
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


#import <JLATTrackingManager/JLATTrackingManager.h>
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation JLATTrackingManager

- (NSNumber *) status {
    if (!_status) {
        _status = @(ATTrackingManagerAuthorizationStatusDenied);
    }
    return _status;
}

- (void) install {
    [super install];
    // TODO: Check if plist is set and throw error or trace
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            self.status = @(status);
            jlog_trace_join(@"ATTracking status ", (status == ATTrackingManagerAuthorizationStatusAuthorized ? @"authorized (" : @"denied ("), self.status, @")");
        }];
    } else {
        jlog_trace(@"ATTracking Not Available");
    }
}

@end
