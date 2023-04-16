//
//  JLUtilsFileSystem.m
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


#import "JLUtilsFileSystem.h"

@implementation JLUtilsFileSystem

- (NSString *)read:(NSString *)path {

    if (!path || [[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        jlog_warning_join(@"Path is empty");
        return @"";
    }

    jlog_trace_fmt(@"Reading File at Path: %@", path);

    NSError *error;

    NSString *content = [NSString
                         stringWithContentsOfFile:path
                                         encoding:NSUTF8StringEncoding
                                            error:&error];

    if ([[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        jlog_notice_join(@"contents of ", path, @" are empty");
    }

    if (error) {
        jlog_error(error.description);
    }

    return content;
}

- (NSString *)read:(NSString *)name extension:(NSString *)ext inBundle:(NSBundle *)bundle {

    NSString *filename = [NSString
                          stringWithFormat:@"%@.%@", name, ext];

    NSString *path = [bundle
                      pathForResource:name
                               ofType:ext];

    jlog_trace_fmt(@"Reading File %@ at Path: %@", filename, path);

    return [self read:path];
}

- (NSString *)read:(NSString *)name extension:(NSString *)ext for:(id)object {
    return [self read:name extension:ext inBundle:[NSBundle bundleForClass:[object class]]];
}

- (NSString *)read:(NSString *)name extension:(NSString *)ext {
    return [self read:name extension:ext inBundle:[NSBundle mainBundle]];
}

- (NSString *)readJS:(NSString *)name inBundle:(NSBundle *)bundle {
    return [self read:name extension:@"js" inBundle:bundle];
}

- (NSString *)readJS:(NSString *)name for:(id)object {
    return [self read:name extension:@"js" for:object];
}

- (NSString *)readJS:(NSString *)name {
    return [self read:name extension:@"js"];
}

- (NSString *)readJSFor:(id)object {
    return [self readJS:NSStringFromClass([object class]) for: object];
}

- (BOOL)isResource:(NSString *)resource {
    return [resource hasPrefix:@"res://"];
}

- (NSString *) pathForFile: (NSString *) name extension: (NSString *) ext inBundle:(NSBundle *) bundle {
    return [bundle pathForResource:name ofType:ext];
}

- (NSString *) pathForFile: (NSString *) name extension: (NSString *) ext for:(id)object {
    return [self pathForFile:name extension:ext inBundle:[NSBundle bundleForClass:[object class]]];
}

- (NSURL *) fileURLForFile: (NSString *) name extension: (NSString *) ext inBundle:(NSBundle *) bundle {
    return [NSURL fileURLWithPath:[self pathForFile:name extension:ext inBundle:bundle]];
}

- (NSURL *) fileURLForFile: (NSString *) name extension: (NSString *) ext for:(id)object {
    return [self fileURLForFile:name extension:ext inBundle:[NSBundle bundleForClass:[object class]]];
}

- (NSString *)pathForResource:(NSString *)resource inBundle:(NSBundle *)bundle {

    // delete res:// constant
    NSString *file = [resource stringByReplacingOccurrencesOfString:@"res://" withString:@""];

    NSString *name = [[file lastPathComponent] stringByDeletingPathExtension];
    NSString *ext = [file pathExtension];

    NSString *path = [bundle
                      pathForResource:name
                               ofType:ext
                          inDirectory:@"Files"];

    return path;
}

- (NSString *)pathForResource:(NSString *)resource {
    return [self pathForResource:resource inBundle:[NSBundle mainBundle]];
}

- (NSURL *)fileURLForPath:(NSString *)path {
    return [NSURL
            URLWithString:[NSString
                           stringWithFormat:@"file://%@", path]];
}

- (NSURL *)resourceDirectoryURLInBundle:(NSBundle *)bundle {
    return [NSURL URLWithString:[NSString
                                 stringWithFormat:@"%@/Files/",
                                 [self fileURLForPath:bundle.resourcePath].absoluteString]];
}

- (NSURL *)resourceDirectoryURL {
    return [self resourceDirectoryURLInBundle:[NSBundle mainBundle]];
}

- (NSURL *) documentDirectoryURL {
    return [[NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (NSString *) uniqueFilename {
    return [NSProcessInfo processInfo].globallyUniqueString;
}

- (NSString *) uniqueFilenameWithExtension: (NSString *) ext {
    NSString * uid = [self uniqueFilename];
    return [NSString stringWithFormat:@"%@.%@", uid, ext];
}

- (NSString *) temp {
    return NSTemporaryDirectory();
}

- (NSString *) tempFile {
    return [[self temp] stringByAppendingPathComponent:[self uniqueFilename]];
}

- (NSString *) tempFilePathWithExtension: (NSString *) ext {
    return [[self temp] stringByAppendingPathComponent:[self uniqueFilenameWithExtension:ext]];
}

- (NSURL *) uniqueFileInDocumentDirectoryWithExtension:(NSString *)ext {
    return [self.documentDirectoryURL URLByAppendingPathComponent:[self uniqueFilenameWithExtension:ext]];
}

- (void) removeFileAtPath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError * error;
        jlog_trace_join(@"Removing file at path %@", path);
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            jlog_warning(error.description);
        }
    }
}
@end
