//
//  JLProcess.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLProcess : NSObject

/// Main Bundle Identifier
@property (nonatomic, strong, nonnull, readonly) NSBundle *bundle;

/// Env arguments stored in ProcessInfo
@property (nonatomic, strong, nonnull, readonly) NSDictionary *environment;

/// NSUserDefaults default storage
@property (nonatomic, strong, nonnull, readonly) NSUserDefaults *storage;

/// Device Information
// TODO: Maybe move this to an own class so you can device.info (dict) device.instance (device object)
@property (nonatomic, strong, nonnull, readonly) NSDictionary *device;

@property (nonatomic, strong, nonnull, readonly) UIScreen *screen;

/// Unique identifiers
@property (nonatomic, strong, nonnull, readonly) NSDictionary *identifiers;

@end

NS_ASSUME_NONNULL_END
