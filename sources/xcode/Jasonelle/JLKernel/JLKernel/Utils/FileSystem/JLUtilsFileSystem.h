//
//  JLUtilsFileSystem.h
//  JLKernel
//
//  Created by clsource on 13-05-22
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
- (NSString *)readJSFor:(id)object;

/// Determines if the string has a res:// prefix
- (BOOL)isResource:(NSString *)resource;

- (NSString *) pathForFile: (NSString *) name extension: (NSString *) ext inBundle:(NSBundle *) bundle;

- (NSString *) pathForFile: (NSString *) name extension: (NSString *) ext for:(id)object;

- (NSURL *) fileURLForFile: (NSString *) name extension: (NSString *) ext inBundle:(NSBundle *) bundle;

- (NSURL *) fileURLForFile: (NSString *) name extension: (NSString *) ext for:(id)object;

- (NSString *)pathForResource:(NSString *)resource inBundle:(NSBundle *)bundle;
- (NSString *)pathForResource:(NSString *)resource;
- (NSURL *)fileURLForPath:(NSString *)path;
- (nonnull NSURL *)resourceDirectoryURLInBundle:(NSBundle *)bundle;
- (nonnull NSURL *)resourceDirectoryURL;
- (nonnull NSURL *) documentDirectoryURL;

// Temporary Files
/// Returns an unique file name
- (NSString *) uniqueFilename;
- (NSString *) uniqueFilenameWithExtension: (NSString *) ext;

/// Returns the temporary directory path
- (NSString *) temp;

/// Returns a temporary file path with an specific extension
- (NSString *) tempFilePathWithExtension: (NSString *) ext;
 
/// Returns a temporary file path
- (NSString *) tempFile;

- (NSURL *) uniqueFileInDocumentDirectoryWithExtension:(NSString *)ext;

- (void) removeFileAtPath: (NSString *) path;

@end

NS_ASSUME_NONNULL_END
