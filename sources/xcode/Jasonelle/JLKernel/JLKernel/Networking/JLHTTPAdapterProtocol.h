//
//  JLHTTPAdapterProtocol.h
//  JLKernel
//
//  Created by clsource on 03-02-22
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

#import <Foundation/Foundation.h>
#import <JLKernel/JLLoggerProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLHTTPResponseProtocol<NSObject>
@end

@protocol JLHTTPRequestProtocol<NSObject>
@end

@protocol JLHTTPAdapterProtocol<NSObject>

@property (nonatomic, strong, readonly) id<JLLoggerProtocol> logger;

- (instancetype)initWithLogger:(id<JLLoggerProtocol>)logger;

/// Base request
// - (nonnull NSURLSessionDataTask *) fetch:(NSString * _Nonnull ) url then:(void (^)(id<JLHTTPAdapterResponse> _Nonnull response)) then;
//
// - (nonnull NSURLSessionDataTask *) fetchRequest:(JLHTTPClientRequest * _Nonnull ) request then:(void (^)(id<JLHTTPAdapterResponse> _Nonnull response)) then;
//
///// Returns a parsed response
// - (nonnull NSURLSessionDataTask *) get:(NSString * _Nonnull ) url then:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, JLHTTPClientResponse * _Nonnull response)) then fail:(void(^ _Nullable )(JLHTTPClientResponse * _Nonnull response, NSError * _Nonnull error)) fail;
//
// - (nonnull NSURLSessionDataTask *) getRequest:(JLHTTPClientRequest * _Nonnull ) request then:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, JLHTTPClientResponse * _Nonnull response)) then fail:(void(^ _Nullable )(JLHTTPClientResponse * _Nonnull response, NSError * _Nonnull error)) fail;

// TODO: Add Post request

@end

NS_ASSUME_NONNULL_END
