//
//  JLNotificationCenter.m
//  JLKernel
//
//  Created by clsource on 19-04-22
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

#import "JLNotificationCenter.h"

@implementation JLNotificationCenter

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];

    if (self) {
        // https://developer.apple.com/documentation/foundation/nsnotificationcenter/1414169-defaultcenter
        // If your app uses notifications extensively, you may want to create and post to your own notification centers rather than posting only to the defaultCenter notification center. When a notification is posted to a notification center, the notification center scans through the list of registered observers, which may slow down your app. By organizing notifications functionally around one or more notification centers, less work is done each time a notification is posted, which can improve performance throughout your app.
        self.center = [NSNotificationCenter new];
        self.logger = logger;
    }

    return self;
}

- (NSNotification *)post:(NSString *)name
                      by:(nullable id)object
                    with:(nullable NSDictionary *)content {
    NSNotification *notification = [NSNotification notificationWithName:name object:object userInfo:content];

    // Uncomment if need more granular logs about notifications
    //    [self.logger
    //     trace: [NSString stringWithFormat:@"Notification: %@", name]
    //     metadata: content
    //     source: NSStringFromClass([object class])
    //     file: nil
    //     function: @(__FUNCTION__)
    //     line: nil];

    [self.center postNotification:notification];

    return notification;
}

@end
