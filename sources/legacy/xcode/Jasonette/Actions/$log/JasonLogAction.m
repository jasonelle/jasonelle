//
//  JasonLogAction.m
//  Jasonette
//
//  Copyright © 2016 seletz. All rights reserved.
//

#include <os/log.h>
#import "JasonLogAction.h"

@implementation JasonLogAction
- (void)info {
    if (self.options) {
        NSString * message = self.options[@"text"];
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_INFO, "%s", [message UTF8String]);
    }

    [[Jason client] success];
}

- (void)debug {
    if (self.options) {
        NSString * message = self.options[@"text"];
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG, "%s", [message UTF8String]);
        NSLog (@"DEBUG: %@", message);
    }

    [[Jason client] success];
}

- (void)error {
    if (self.options) {
        NSString * message = self.options[@"text"];
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_ERROR, "%s", [message UTF8String]);
        NSLog (@"ERROR: %@", message);
    }

    [[Jason client] success];
}

@end
