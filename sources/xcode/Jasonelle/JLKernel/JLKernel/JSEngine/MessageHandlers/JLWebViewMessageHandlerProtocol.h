//
//  JLWebViewMessageHandlerProtocol.h
//  JLKernel
//
//  Created by clsource on 15-05-22
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


#import <Foundation/Foundation.h>
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@protocol JLWebViewMessageHandlerProtocol <NSObject>

// Defined in WKScriptMessageHandlerWithReply protocol
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message replyHandler:(void (^)(id _Nullable reply, NSString * _Nullable errorMessage)) replyHandler WK_SWIFT_ASYNC(3) API_AVAILABLE(macos(11.0), ios(14.0));

@end

NS_ASSUME_NONNULL_END
