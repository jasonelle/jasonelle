//
//  JLEnvironment.m
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

#import "JLEnvironment.h"

@implementation JLEnvironment

- (JLProcess *)process {
    if (!_process) {
        _process = [JLProcess new];
    }

    return _process;
}

- (JLEnvironmentType)type {
    if (!_type) {
        _type = [self detect];
    }

    return _type;
}

- (JLEnvironmentType)detect {
    if (NSClassFromString(@"XCTest") != nil) {
        return JLEnvironmentTypeTesting;
    }

   #if DEBUG
        return JLEnvironmentTypeDevelop;

   #else
        return JLEnvironmentTypeProduction;

   #endif
}

- (instancetype)initWithApplication:(UIApplication *)application andLaunchOptions:(nullable NSDictionary *)launchOptions {
    JLEnvironment *env = [JLEnvironment new];

    env.application = application;
    env.arguments = launchOptions;
    return env;
}

@end
