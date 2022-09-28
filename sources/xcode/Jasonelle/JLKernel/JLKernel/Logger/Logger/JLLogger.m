//
//  JLLogger.m
//  JLKernel
//
//  Created by clsource on 02-02-22
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

#import "JLLogger.h"
#import <JLKernel/JLLogLevelFactory.h>

@implementation JLLogger

@synthesize label;
@synthesize handler;
@synthesize metadata;

- (nonnull instancetype)initWithLabel:(nonnull NSString *)label andHandler:(nonnull id<JLLogHandlerProtocol>)handler {
    self.label = label;
    self.handler = handler;
    return self;
}

- (nullable NSString *)log:(nonnull JLLogLevel *)level message:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    if (self.handler.level.severity > level.severity) {
        return nil;
    }

    return [self.handler log:level
                     message:message
                    metadata:metadata
                      source:source
                        file:file
                    function:func
                        line:line];
}

#pragma mark - Log Levels
#pragma mark Trace
- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory trace] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)trace:(nonnull NSString *)message {
    return [self trace:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)trace:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self trace:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self trace:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self trace:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self trace:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self trace:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)trace:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self trace:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self trace:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)trace:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self trace:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)trace:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self trace:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Debug

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory debug] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)debug:(nonnull NSString *)message {
    return [self debug:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)debug:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self debug:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self debug:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self debug:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self debug:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self debug:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)debug:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self debug:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self debug:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)debug:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self debug:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)debug:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self debug:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Info

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory info] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)info:(nonnull NSString *)message {
    return [self info:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)info:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self info:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self info:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self info:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self info:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self info:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)info:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self info:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self info:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)info:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self info:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)info:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self info:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Notice

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory notice] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)notice:(nonnull NSString *)message {
    return [self notice:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)notice:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self notice:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self notice:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self notice:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self notice:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self notice:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)notice:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self notice:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self notice:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)notice:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self notice:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)notice:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self notice:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Warning

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory warning] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)warning:(nonnull NSString *)message {
    return [self warning:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)warning:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self warning:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self warning:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self warning:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self warning:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self warning:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)warning:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self warning:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self warning:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)warning:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self warning:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)warning:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self warning:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Error

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory error] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)error:(nonnull NSString *)message {
    return [self error:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)error:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self error:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self error:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self error:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self error:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self error:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)error:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self error:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self error:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)error:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self error:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)error:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self error:message metadata:nil source:source file:file function:func line:line];
}

#pragma mark Critical

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self log:[JLLogLevelFactory critical] message:message metadata:metadata source:source file:file function:func line:line];
}

- (nullable NSString *)critical:(nonnull NSString *)message {
    return [self critical:message metadata:nil source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)critical:(nonnull NSString *)message function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self critical:message metadata:nil source:nil file:nil function:func line:line];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata {
    return [self critical:message metadata:metadata source:nil file:nil function:nil line:nil];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source {
    return [self critical:message metadata:metadata source:source file:nil function:nil line:nil];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file {
    return [self critical:message metadata:metadata source:source file:file function:nil line:nil];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func {
    return [self critical:message metadata:metadata source:source file:file function:func line:nil];
}

- (nullable NSString *)critical:(nonnull NSString *)message file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self critical:message metadata:nil source:nil file:file function:func line:line];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self critical:message metadata:metadata source:nil file:file function:func line:line];
}

- (nullable NSString *)critical:(nonnull NSString *)message metadata:(nullable NSDictionary *)metadata function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self critical:message metadata:metadata source:nil file:nil function:func line:line];
}

- (nullable NSString *)critical:(nonnull NSString *)message source:(nullable NSString *)source file:(nullable NSString *)file function:(nullable NSString *)func line:(nullable NSNumber *)line {
    return [self critical:message metadata:nil source:source file:file function:func line:line];
}

@end
