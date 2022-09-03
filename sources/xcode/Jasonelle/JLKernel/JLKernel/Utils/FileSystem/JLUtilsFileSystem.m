//
//  JLUtilsFileSystem.m
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

- (BOOL)isResource:(NSString *)resource {
    return [resource hasPrefix:@"res://"];
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
@end
