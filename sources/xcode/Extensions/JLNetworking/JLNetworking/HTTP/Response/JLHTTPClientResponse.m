//
//  JLHTTPClientResponse.m
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

#import "JLHTTPClientResponse.h"

@implementation JLHTTPClientResponse

// Conflicts with internal variables? so we named uniquely
@synthesize status = _httpStatus;

- (NSHTTPURLResponse *) http {
    return (NSHTTPURLResponse *) self.response;
}

- (NSDictionary *) headers {
    return [self.http allHeaderFields];
}

- (JLHTTPClientResponseStatus *) status {
    if (!_httpStatus) {
        NSUInteger code = [self.http statusCode];
        _httpStatus = [[JLHTTPClientResponseStatus alloc] initWithCode:code];
    }
    return _httpStatus;
}

- (BOOL) success {
    return (self.data && !self.error);
}

- (void) text:(void (^)(NSString * _Nullable body, NSError * error))then {
    if(self.error) {
        return then(nil, self.error);
    }
    
    // Automatically detect string encoding
    NSString * text;
    (void)[NSString stringEncodingForData:self.data encodingOptions:nil convertedString:&text usedLossyConversion:nil];
    
    then(text, nil);
}

- (void) json:(void (^)(NSDictionary * _Nullable json, NSError * error))then {
    if(self.error) {
        return then(nil, self.error);
    }
    
    NSError *jsonError;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&jsonError];

    if (jsonError) {
        // Error Parsing JSON
        return then(nil, jsonError);
    }
    
    return then(jsonResponse, nil);
}

- (void) parse:(void (^)(id _Nullable body, JLHTTPClientResponseContentType contentType, NSError * error))then {
    
    NSString * contentType = [self.headers[@"content-type"] lowercaseString];
    
    if ([contentType containsString:@"json"]) {
        [self json:^(NSDictionary * _Nullable json, NSError * _Nonnull error) {
            then(json,JLHTTPClientResponseContentTypeJSON,error);
        }];
        return;
    }
    
    if ([contentType containsString:@"text"] || [contentType containsString:@"application"]) {
        [self text:^(NSString * _Nullable body, NSError * _Nonnull error) {
            
            JLHTTPClientResponseContentType type = JLHTTPClientResponseContentTypeText;
            
            if ([contentType containsString:@"xml"]) {
                type = JLHTTPClientResponseContentTypeXML;
            }
            
            if ([contentType containsString:@"javascript"] || [contentType containsString:@"ecmascript"]) {
                type = JLHTTPClientResponseContentTypeJS;
            }
            
            if ([contentType containsString:@"html"]) {
                type = JLHTTPClientResponseContentTypeHTML;
            }
            
            if([contentType containsString:@"css"]) {
                type = JLHTTPClientResponseContentTypeCSS;
            }
            
            then(body, type, error);
        }];
        return;
    }
    
    JLHTTPClientResponseContentType type = JLHTTPClientResponseContentTypeData;
    
    if([contentType containsString:@"image"]) {
        type = JLHTTPClientResponseContentTypeImage;
    }
    
    if([contentType containsString:@"audio"]) {
        type = JLHTTPClientResponseContentTypeAudio;
    }
    
    if([contentType containsString:@"video"]) {
        type = JLHTTPClientResponseContentTypeVideo;
    }
    
    if([contentType containsString:@"font"]) {
        type = JLHTTPClientResponseContentTypeFont;
    }
    
    then(self.data, type, self.error);
}
@end
