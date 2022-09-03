//
//  JLStreamLogHandler.h
//  JLKernel
//
//  Created by clsource on 02-02-22
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
#import <JLKernel/JLLogHandlerProtocol.h>

typedef NS_ENUM(NSUInteger, JLStream) {
    JLStreamStdio,
    JLStreamStderr
};

NS_ASSUME_NONNULL_BEGIN

@interface JLStreamLogHandler : NSObject<JLLogHandlerProtocol>

@property (nonatomic, strong, nonnull) NSString * label;
@property (nonatomic) JLStream stream;

- (instancetype) initWithLabel: (nonnull NSString *) label andStream:(JLStream) stream;

+ (instancetype) standardOutput:(nonnull NSString *) label;
+ (instancetype) standardError:(nonnull NSString *) label;

@end

NS_ASSUME_NONNULL_END
