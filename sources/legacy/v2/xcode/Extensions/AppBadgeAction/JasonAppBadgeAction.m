//
//  JasonAppBadgeAction.m
//  Jasonette.com
//
//  Created by Camilo Castro on 22-05-22.
//  Copyright © 2022 Jasonette.com. All rights reserved.
//

#import "JasonAppBadgeAction.h"
#import <UIKit/UIKit.h>
#import "JasonLogger.h"

@implementation JasonAppBadgeAction

- (void) set {
    NSNumber * number = self.options[@"number"];
    DTLogDebug(@"Setting App Badge Number: %@", number);
    [UIApplication sharedApplication].applicationIconBadgeNumber = number.intValue;
    [[Jason client] success:@{
        @"number": @([UIApplication sharedApplication].applicationIconBadgeNumber)
    }];
}

- (void) get {
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
    DTLogDebug(@"Getting App Badge Number: %lu", number);
    [[Jason client] success:@{
        @"number": @(number)
    }];
}

- (void) clear {
    DTLogDebug(@"Clearing App Badge Number");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[Jason client] success:@{
        @"number": @0
    }];
}

@end
