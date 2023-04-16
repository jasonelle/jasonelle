//
//  JLApplication.m
//  JLKernel
//
//  Created by clsource on 03-02-22
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

#import "JLApplication.h"

@implementation JLApplication

static JLApplication *_instance;

+ (instancetype)instance {
    return _instance;
}

+ (void)setInstance:(JLApplication *)instance {
    _instance = instance;
}

- (JLApplicationVersion *)version {
    if (!_version) {
        _version = [JLApplicationVersion new];
    }

    return _version;
}

- (UIViewController *) rootController {
    
    // Sometimes is needed a root controller to show alerts in webviews (using SwiftUI)
    // so we use the first available controller
    // before ios 13 something like this would be used
    //
    // UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    //
    // but since it was deprecated we now have to iterate between scenes
    // to find the key window controller
    
    if (!_rootController) {
        
        UIViewController * controller = nil;
        
        for (UIWindowScene * scene in [[UIApplication sharedApplication] connectedScenes]) {
            
            if (controller) break;
            
            for (UIWindow * window in scene.windows) {
                if (window.isKeyWindow) {
                    controller = window.rootViewController;
                    break;
                }
            }
        }
        _rootController = controller;
    }
    
    return _rootController;
}

// - (JLApplicationHTTP *)http {
//    if (!_http) {
//        _http = [JLApplicationHTTP new];
//    }
//
//    return _http;
// }

- (JLJSContext *)js {
    if (!_js) {
        _js = [[JLJSContext alloc]
               initWithLogger:self.logger
                 andSourceURL:nil];
    }

    return _js;
}

- (JLJSConfigLoader *)config {
    if (!_config) {
        _config = [[JLJSConfigLoader alloc] initWithContext:self.js];
    }

    return _config;
}

- (JLJSRoutesLoader *)routes {
    if (!_routes) {
        _routes = [[JLJSRoutesLoader alloc] initWithContext:self.js];
    }

    return _routes;
}

- (JLApplicationEvents *)events {
    if (!_events) {
        _events = [JLApplicationEvents new];
    }

    return _events;
}

- (JLNotificationCenter *)notifications {
    if (!_notifications) {
        _notifications = [[JLNotificationCenter alloc] initWithLogger:self.logger];
    }

    return _notifications;
}

- (JLApplicationUtils *)utils {
    if (!_utils) {
        _utils = [[JLApplicationUtils alloc] initWithLogger:self.logger andRootController:self.rootController];
    }

    return _utils;
}

- (JLApplicationExtensions *)ext {
    if (!_ext) {
        _ext = [[JLApplicationExtensions alloc] initWithApplication:self andLogger:self.logger];
    }

    return _ext;
}

@end
