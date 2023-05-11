//
//  JLEnvironment.h
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

#import <UIKit/UIKit.h>
#import <JLKernel/JLProcess.h>

typedef NS_ENUM(NSUInteger, JLEnvironmentType) {
    JLEnvironmentTypeProduction,
    JLEnvironmentTypeDevelop,
    JLEnvironmentTypeTesting,
    JLEnvironmentTypeUITesting
};

typedef NS_ENUM(NSUInteger, JLEnvironmentDevice) {
    JLEnvironmentDeviceSimulator,
    JLEnvironmentDeviceHardware
};

NS_ASSUME_NONNULL_BEGIN

@interface JLEnvironment : NSObject

/// Application passed on application launch
@property (nonatomic, strong, nonnull) UIApplication *application;

/// Arguments passed on application launch
@property (nonatomic, strong, nullable) NSDictionary *arguments;

@property (nonatomic, strong, nonnull) JLProcess *process;
@property (nonatomic) JLEnvironmentType type;
@property (nonatomic) JLEnvironmentDevice device;
@property (nonatomic) BOOL licensed;
@property (nonatomic, strong, nullable) NSString *licenseKey;

- (instancetype)initWithApplication:(UIApplication *)application andLaunchOptions:(nullable NSDictionary *)launchOptions;

- (JLEnvironmentType)detect;

- (NSDictionary *) toDictionary;
@end

NS_ASSUME_NONNULL_END
