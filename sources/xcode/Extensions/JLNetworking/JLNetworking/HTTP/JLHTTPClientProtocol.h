//
//  JLHTTPClientProtocol.h
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
#import <JLKernel/JLHTTPClientResponse.h>
#import <JLKernel/JLHTTPClientRequest.h>
#import <JLKernel/JLLoggerProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLHTTPClientProtocol <NSObject>

@property (nonatomic, strong, readonly) id<JLLoggerProtocol> logger;

- (instancetype) initWithLogger:(id<JLLoggerProtocol>)logger;

/// Base request
- (nonnull NSURLSessionDataTask *) fetch:(NSString * _Nonnull ) url then:(void (^)(JLHTTPClientResponse * _Nonnull response)) then;

- (nonnull NSURLSessionDataTask *) fetchRequest:(JLHTTPClientRequest * _Nonnull ) request then:(void (^)(JLHTTPClientResponse * _Nonnull response)) then;

/// Returns a parsed response
- (nonnull NSURLSessionDataTask *) get:(NSString * _Nonnull ) url then:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, JLHTTPClientResponse * _Nonnull response)) then fail:(void(^ _Nullable )(JLHTTPClientResponse * _Nonnull response, NSError * _Nonnull error)) fail;

- (nonnull NSURLSessionDataTask *) getRequest:(JLHTTPClientRequest * _Nonnull ) request then:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, JLHTTPClientResponse * _Nonnull response)) then fail:(void(^ _Nullable )(JLHTTPClientResponse * _Nonnull response, NSError * _Nonnull error)) fail;

// TODO: Add Post request

@end

NS_ASSUME_NONNULL_END
