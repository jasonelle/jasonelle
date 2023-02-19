//
//  JLHTTPClient.m
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

#import "JLHTTPClient.h"

@implementation JLHTTPClient

@synthesize logger = _logger;

- (instancetype) initWithLogger:(id<JLLoggerProtocol>)logger {
    self = [super init];
    _logger = logger;
    return self;
}

- (nonnull NSURLSessionDataTask *)fetchRequest:(JLHTTPClientRequest * _Nonnull)request then:(nonnull void (^)(JLHTTPClientResponse * _Nonnull))then {
    
    NSURLSession * session = request.session;
    JLHTTPClientResponse * res = [JLHTTPClientResponse new];
    res.request = request;
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        res.data = data;
        res.response = response;
        res.error = error;
        then(res);
    }];
    
    res.task = task;
    return task;
}

- (nonnull NSURLSessionDataTask *) fetch:(NSString * _Nonnull) url then:(void (^)(JLHTTPClientResponse * _Nonnull response)) then {
    JLHTTPClientRequest * request = [[JLHTTPClientRequest alloc] initWithURL:url];
    return [self fetchRequest:request then:then];
}

- (nonnull NSURLSessionDataTask *)getRequest:(JLHTTPClientRequest * _Nonnull)request then:(nonnull void (^)(id _Nullable, JLHTTPClientResponseContentType, JLHTTPClientResponse * _Nonnull))then fail:(void (^ _Nullable )(JLHTTPClientResponse * _Nonnull, NSError * _Nonnull))fail {
    
    NSURLSessionDataTask * task = [self fetchRequest:request then:^(JLHTTPClientResponse * _Nonnull response) {
        [response parse:^(id  _Nullable body, JLHTTPClientResponseContentType contentType, NSError * _Nonnull error) {
            if (error) {
                if (fail) {
                    return fail(response, error);
                }
                // TODO: Add logger for errors? or require not nil fail handler? or sent an event?
                [self.logger warning:[NSString stringWithFormat:@"fail block not found: %@ %@ %@", error, @(__PRETTY_FUNCTION__), @(__LINE__)]];
                
                return;
            }
            return then(body, contentType, response);
        }];
    }];
    
    [task resume];
    return task;
}

- (nonnull NSURLSessionDataTask *)get:(NSString * _Nonnull)url then:(nonnull void (^)(id _Nullable, JLHTTPClientResponseContentType, JLHTTPClientResponse * _Nonnull))then fail:(void (^ _Nullable )(JLHTTPClientResponse * _Nonnull, NSError * _Nonnull))fail {
    JLHTTPClientRequest * request = [[JLHTTPClientRequest alloc] initWithURL:url];
    return [self getRequest:request then:then fail:fail];
}


@end
