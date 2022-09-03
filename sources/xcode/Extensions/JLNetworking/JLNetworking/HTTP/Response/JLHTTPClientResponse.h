//
//  JLHTTPClientResponse.h
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
#import <JLKernel/JLHTTPClientRequest.h>
#import <JLKernel/JLHTTPClientResponseStatus.h>

typedef NS_ENUM(NSUInteger, JLHTTPClientResponseContentType) {
    JLHTTPClientResponseContentTypeText,
    JLHTTPClientResponseContentTypeHTML,
    JLHTTPClientResponseContentTypeJSON,
    JLHTTPClientResponseContentTypeXML,
    JLHTTPClientResponseContentTypeJS,
    JLHTTPClientResponseContentTypeCSS,
    JLHTTPClientResponseContentTypeImage,
    JLHTTPClientResponseContentTypeAudio,
    JLHTTPClientResponseContentTypeVideo,
    JLHTTPClientResponseContentTypeFont,
    JLHTTPClientResponseContentTypeData
};

NS_ASSUME_NONNULL_BEGIN

@interface JLHTTPClientResponse : NSObject

@property (nonatomic, strong, nullable) NSData * data;
@property (nonatomic, strong, nullable) NSURLResponse * response;
@property (nonatomic, strong, nullable) NSError * error;
@property (nonatomic, strong, nullable) NSURLSessionDataTask * task;
@property (nonatomic, strong, nullable) JLHTTPClientRequest * request;

// Computed properties
@property (nonatomic, readonly) NSHTTPURLResponse * http;
@property (nonatomic, readonly) NSDictionary * headers;
@property (nonatomic, strong, readonly) JLHTTPClientResponseStatus * status;

/// Data is present and error is nil
@property (nonatomic, readonly) BOOL success;


/// Read the data as a text object
- (void) text:(void (^)(NSString * _Nullable body, NSError * error))then;

/// Read the data as a json object
- (void) json:(void (^)(NSDictionary * _Nullable json, NSError * error))then;

/// Reads the Content-Type header and returns NSString, NSData or JSON respectively
- (void) parse:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, NSError * error))then;

@end

NS_ASSUME_NONNULL_END
