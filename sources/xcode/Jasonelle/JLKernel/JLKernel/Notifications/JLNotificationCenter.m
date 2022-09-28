//
//  JLNotificationCenter.m
//  JLKernel
//
//  Created by clsource on 19-04-22
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
