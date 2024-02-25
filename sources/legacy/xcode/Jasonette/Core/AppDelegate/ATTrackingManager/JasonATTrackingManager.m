//
//  JasonATTrackingManager.m
//  Jasonette
//
//  Created by Jasonelle Team on 17-06-21.
//  Copyright © 2021 Jasonette. All rights reserved.
//

#import "JasonATTrackingManager.h"
#import "JasonLogger.h"
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation JasonATTrackingManager

+ (void) showWithSettings: (NSDictionary *) settings {
    
    DTLogDebug(@"Checking ATTracking");
    
    if (@available(iOS 14, *)) {
        BOOL trackingEnabled = [settings[@"tracking_enabled"] boolValue];
        if (trackingEnabled) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                DTLogDebug (@"ATTracking status %d", status);
            }];
        } else {
            DTLogDebug (@"ATTracking is disabled.");
        }
    } else {
        DTLogDebug(@"iOS < 14.5 ATTracking not needed.");
    }
}

@end
