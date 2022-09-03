//
//  JLHTTPClientRequest.m
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

#import "JLHTTPClientRequest.h"

@implementation JLHTTPClientRequest

- (nonnull NSURLSession *) session {
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

- (nonnull NSURLSessionConfiguration *) config {
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}

- (instancetype) initWithURL:(nonnull NSString *) url {
    
    self = [super init];
    
    NSCharacterSet * allowed = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    NSString * encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:allowed];

    self.urlString = encodedUrl;
    self.url = [NSURL URLWithString:url];
    self.request = [NSURLRequest requestWithURL:self.url];
    return self;
}

- (instancetype) initWithURL:(nonnull NSString *) url session:(nullable NSURLSession *) session andConfiguration:(nullable NSURLSessionConfiguration *) config {
    JLHTTPClientRequest * request = [[JLHTTPClientRequest alloc] initWithURL:url];
    request.session = session;
    request.config = config;
    return request;
}

- (instancetype) initWithRequest:(nonnull NSURLRequest *) request {
    self = [super init];
    self.request = request;
    self.url = [request URL];
    self.urlString = [self.url absoluteString];
    return self;
}

- (instancetype) initWithRequest:(NSURLRequest *)request session:(nullable NSURLSession *) session andConfiguration:(nullable NSURLSessionConfiguration *) config {
    JLHTTPClientRequest * req = [[JLHTTPClientRequest alloc] initWithRequest:request];
    req.session = session;
    req.config = config;
    return req;
}

@end
