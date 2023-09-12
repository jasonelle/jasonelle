//
//  JLShareShowHandler.m
//  JLShare
//
//  Created by clsource on 12-09-23.
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

#import "JLShareShowHandler.h"

typedef NS_ENUM(NSUInteger, JLShareTypes) {
    JLShareTypeText = 0,
    JLShareTypeURL
};

// https://nshipster.com/uiactivityviewcontroller/
// https://developer.apple.com/documentation/uikit/uiactivityviewcontroller

@implementation JLShareShowHandler


- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    
    jlog_info(@"Triggered $share.show");
    
    JLJSParams * opts = [options toParams];
    
    NSArray * items = [self itemsForOptions:opts];
    
    UIActivityViewController * controller = [self prepareShareControllerWithItems:items];
    
    // Present the controller
    [controller setCompletionWithItemsHandler:
     ^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError) {
        
        jlog_trace(@"$share.show completed");
        
        if (activityError) {
            jlog_error(activityError.description);
        }
        
        self.resolve(@YES);
     }];
    
    [self.app.utils present:controller completion:nil];
}

- (NSArray *) itemsForOptions: (JLJSParams *) options {
    
    NSMutableArray * items = [@[] mutableCopy];
    
    JLShareTypes type = [[options number:@"type" default:@(0)] intValue];
    
    jlog_info_join(@"$share.show with type: ", @(type));
    
    
    // Note: Sharing URL to a single file
    // like: images, pdf, audio or videos
    // will automatically detect the proper type
    // so it's best to only support text and url types
    // for now.

    switch(type) {
        case JLShareTypeURL:
            [items addObject:[self getURLInOptions:options]];
            break;
        
        case JLShareTypeText:
        default:
            [items addObject:[self getValueInOptions:options]];
            break;
    }
    
    return [items copy];
}

- (NSString *) getValueInOptions: (JLJSParams *) options {
    return [options string:@"value" default:@""];
}

- (id) getURLInOptions: (JLJSParams *) options {
    NSString * value = [self getValueInOptions:options];
    NSURL * url = [NSURL URLWithString:value];
    
    // The value can be a valid or invalid url
    // if is not nil then is a valid url
    if (url) {
        return url;
    }
    
    // otherwise we return the original value as text
    return value;
}

- (UIActivityViewController *) prepareShareControllerWithItems:(NSArray *)items {
    
    jlog_trace_join(@"$share items:", items.description);

    UIActivityViewController * controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];

    // Exclude all activities except AirDrop.
    NSArray * excludeActivities = @[UIActivityTypePostToFlickr, UIActivityTypePostToVimeo];

    controller.excludedActivityTypes = excludeActivities;

    if (controller.popoverPresentationController) {
        controller.popoverPresentationController.sourceView = self.app.rootController.view;
    }
    
    return controller;
}

@end
