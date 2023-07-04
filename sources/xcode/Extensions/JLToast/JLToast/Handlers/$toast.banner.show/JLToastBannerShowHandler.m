//
//  JLToastBannerShowHandler.m
//  JLToast
//
//  Created by clsource on 01-07-23.
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

#import "JLToastBannerShowHandler.h"
#import "JDStatusBarNotification.h"

typedef NS_ENUM(NSUInteger, JLToastTypes) {
    JLToastTypeDefault = 0,
    JLToastTypeDark,
    JLToastTypeError,
    JLToastTypeSuccess,
    JLToastTypeWarning,
    JLToastTypeInfo
};

@implementation JLToastBannerShowHandler

- (NSTimeInterval) durationForOptions: (JLJSParams *) options {
    return [[options number:@"duration" default:@(3.0)] doubleValue];
}

- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    JLJSParams * params = [options toParams];
        
    JLJSParams * opts = [params get:@"options"];
    
    JLToastTypes type = [[opts number:@"type" default:@(JLToastTypeDefault)] intValue];
    
    NSString * text = [params string:@"text" default:@""];
    
    jlog_trace_join(@"Toast Banner with Type: ", @(type), @" and Text: ", text);
    
    switch (type) {
        case JLToastTypeDark:
            [self showToastDarkWithText:text andOptions:opts];
            break;
        case JLToastTypeError:
            [self showToastErrorWithText:text andOptions:opts];
            break;
        case JLToastTypeSuccess:
            [self showToastSuccessWithText:text andOptions:opts];
            break;
        case JLToastTypeWarning:
            [self showToastWarningWithText:text andOptions:opts];
            break;
        case JLToastTypeInfo:
            [self showToastInfoWithText:text andOptions:opts];
            break;
        case JLToastTypeDefault:
        default:
            [self showToastDefaultWithText:text andOptions:opts];
            break;
    }
    
    self.resolve(@YES);
}

#pragma mark - Toasts

- (void) showToastDefaultWithText: (NSString *) text andOptions:(JLJSParams *) options {
    jlog_trace(@"Show Toast Banner");
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleDefaultStyle];
}

- (void) showToastDarkWithText: (NSString *) text andOptions:(JLJSParams *) options {
    jlog_trace(@"Show Toast Dark");
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleDark];
}

- (void) showToastErrorWithText: (NSString *) text andOptions:(JLJSParams *) options {
    jlog_trace(@"Show Toast Error");
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleError];
}

- (void) showToastSuccessWithText: (NSString *) text andOptions:(JLJSParams *) options {
    
    jlog_trace(@"Show Toast Success");
    
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleSuccess];
}

- (void) showToastWarningWithText: (NSString *) text andOptions:(JLJSParams *) options {
    jlog_trace(@"Show Toast Warning");
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleWarning];
}

- (void) showToastInfoWithText: (NSString *) text andOptions:(JLJSParams *) options {
    jlog_trace(@"Show Toast Info");
    [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:text dismissAfterDelay:[self durationForOptions:options] includedStyle:JDStatusBarNotificationIncludedStyleDefaultStyle];
}
@end
