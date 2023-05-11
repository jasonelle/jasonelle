//
//  JLEnvironment.m
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

- (NSString *) typeString {
    if (self.type == JLEnvironmentTypeTesting) {
        return @"testing";
    }
    
    if (self.type == JLEnvironmentTypeDevelop) {
        return @"develop";
    }
    
    return @"production";
}

- (JLEnvironmentDevice)device {
    if (self.process.environment[@"SIMULATOR_DEVICE_NAME"] != nil) {
        return JLEnvironmentDeviceSimulator;
    }
    return JLEnvironmentDeviceHardware;
}

- (NSString *) deviceString {
    return (self.device == JLEnvironmentDeviceSimulator ? @"simulator": @"hardware");
}

- (instancetype)initWithApplication:(UIApplication *)application andLaunchOptions:(nullable NSDictionary *)launchOptions {
    JLEnvironment *env = [JLEnvironment new];

    env.application = application;
    env.arguments = launchOptions;
    return env;
}

- (NSDictionary *) toDictionary {
    return @{
        @"license": @{
            @"enabled": @(self.licensed)
        },
        @"process": [self.process toDictionary],
        @"env": @{
            @"type": @{
                @"id": @(self.type),
                @"name": self.typeString
            },
            @"hw": @{
                @"id": @(self.device),
                @"name": self.deviceString
            }
        }
    };
}

@end
