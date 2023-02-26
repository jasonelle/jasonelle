//
//  MyExtensionHandler.m
//  MyExtension
//
//  Created by clsource on 18-02-23.
//  Copyright (c) 2023 Jasonelle.com
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

#import "MyExtensionHandler.h"
#import "MyExtension.h"

@implementation MyExtensionHandler

- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    MyExtension * ext = (MyExtension *) self.extension;
    jlog_trace(ext.message);
    
    // Send an event to the hook if is present
    // this hook must be defined in main.js file
    // in the hooks section:
    // hooks = {
    //    onExampleEvent(message) {
    //        log(message);
    //    },
    // }
    // NOTE: main.js does not have webview access yet.
    JLJSParams * hook = [self.app.hooks get:@"onExampleEvent"];
    JLJSValue * func = hook.value;
    [func secureCallWith:ext.message];
    
    // Dispatch an event inside the webview
    [self.app.utils.webview
     dispatch:@"window.$myextension.events.example.dispatch"
     arguments: @{
        @"message": ext.message
     }
     inWebView:ext.webview
    ];
    
    // Resolve the promise. Always must call self.resolve() or self.reject() at the end.
    self.resolve(ext.message);
}

@end
