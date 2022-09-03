//
//  JLUtilsFileSystem.h
//  JLKernel
//
//  Created by clsource on 13-05-22
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


#import <JLKernel/JLUtil.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLUtilsFileSystem : JLUtil

- (NSString *)read:(nonnull NSString *)path;

- (NSString *)read:(NSString *)name extension:(NSString *)ext inBundle:(NSBundle *)bundle;
- (NSString *)read:(NSString *)name extension:(NSString *)ext for:(id)object;
- (NSString *)read:(NSString *)name extension:(NSString *)ext;

- (NSString *)readJS:(NSString *)name inBundle:(NSBundle *)bundle;
- (NSString *)readJS:(NSString *)name for:(id)object;
- (NSString *)readJS:(NSString *)name;

- (BOOL)isResource:(NSString *)resource;
- (NSString *)pathForResource:(NSString *)resource inBundle:(NSBundle *)bundle;
- (NSString *)pathForResource:(NSString *)resource;
- (NSURL *)fileURLForPath:(NSString *)path;
- (nonnull NSURL *)resourceDirectoryURLInBundle:(NSBundle *)bundle;
- (nonnull NSURL *)resourceDirectoryURL;
@end

NS_ASSUME_NONNULL_END
