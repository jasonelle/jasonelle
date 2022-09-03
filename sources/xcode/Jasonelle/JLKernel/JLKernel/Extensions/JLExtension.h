//
//  JLExtension.h
//  JLKernel
//
//  Created by clsource on 06-05-22
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
#import <JLKernel/JLLoggerProtocol.h>

@class JLApplication;

NS_ASSUME_NONNULL_BEGIN

@protocol JLExtensionProtocol<NSObject>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) JLApplication *app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

- (instancetype)initWithName:(NSString *)name
                      logger:(id<JLLoggerProtocol>)logger
                      andApp:(JLApplication *)app;

- (void)install;

+ (instancetype)instanceWithLogger:(id<JLLoggerProtocol>)logger
                            andApp:(JLApplication *)app;

@optional
@property (nonatomic, strong) NSDictionary *handlers;
- (nonnull NSDictionary *)installHandlers:(nonnull NSDictionary *)handlers;

@end

@interface JLExtension : NSObject<JLExtensionProtocol>

/// Returns the namespace for the specific class name
+ (NSString *)namespaceForClass:(Class)class;

/// Unique name with namespace added
+ (NSString *)name;

@end

NS_ASSUME_NONNULL_END
