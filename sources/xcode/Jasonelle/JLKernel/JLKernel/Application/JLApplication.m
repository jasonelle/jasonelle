//
//  JLApplication.m
//  JLKernel
//
//  Created by clsource on 03-02-22
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
        _utils = [[JLApplicationUtils alloc] initWithLogger:self.logger];
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
