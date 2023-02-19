//
//  JLHTTPClientRequest.h
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

NS_ASSUME_NONNULL_BEGIN

@interface JLHTTPClientRequest : NSObject
@property (nonatomic, strong, nonnull) NSURLSession * session;
@property (nonatomic, strong, nonnull) NSURLSessionConfiguration * config;
@property (nonatomic, strong, nonnull) NSURLRequest * request;
@property (nonatomic, strong, nonnull) NSURL * url;
@property (nonatomic, strong, nonnull) NSString * urlString;

- (instancetype) initWithURL:(nonnull NSString *) url;

- (instancetype) initWithURL:(nonnull NSString *) url session:(nullable NSURLSession *) session andConfiguration:(nullable NSURLSessionConfiguration *) config;

- (instancetype) initWithRequest:(nonnull NSURLRequest *) request;

- (instancetype) initWithRequest:(NSURLRequest *)request session:(nullable NSURLSession *) session andConfiguration:(nullable NSURLSessionConfiguration *) config;
@end

NS_ASSUME_NONNULL_END
