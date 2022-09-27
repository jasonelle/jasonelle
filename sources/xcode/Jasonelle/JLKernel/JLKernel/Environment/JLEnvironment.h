//
//  JLEnvironment.h
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

#import <UIKit/UIKit.h>
#import <JLKernel/JLProcess.h>

typedef NS_ENUM(NSUInteger, JLEnvironmentType) {
    JLEnvironmentTypeProduction,
    JLEnvironmentTypeDevelop,
    JLEnvironmentTypeTesting,
    JLEnvironmentTypeUITesting,
    JLEnvironmentTypeRelease
};

NS_ASSUME_NONNULL_BEGIN

@interface JLEnvironment : NSObject

/// Application passed on application launch
@property (nonatomic, strong, nonnull) UIApplication *application;

/// Arguments passed on application launch
@property (nonatomic, strong, nullable) NSDictionary *arguments;

@property (nonatomic, strong, nonnull) JLProcess *process;
@property (nonatomic) JLEnvironmentType type;
@property (nonatomic) BOOL licensed;

- (instancetype)initWithApplication:(UIApplication *)application andLaunchOptions:(nullable NSDictionary *)launchOptions;

- (JLEnvironmentType)detect;

@end

NS_ASSUME_NONNULL_END
