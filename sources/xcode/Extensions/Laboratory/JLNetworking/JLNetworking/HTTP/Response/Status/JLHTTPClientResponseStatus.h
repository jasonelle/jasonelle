//
//  JLHTTPClientResponseStatus.h
//  JLKernel
//
//  Created by clsource on 04-02-22
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

/// Based on: https://github.com/rafiki270/HTTP-Status-Codes-for-Objective-C
/// http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
typedef NS_ENUM(NSUInteger, JLHTTPClientResponseStatusCode) {
    // Informational
   HTTPCode1XXInformationalUnknown = 1,
   HTTPCode100Continue = 100,
   HTTPCode101SwitchingProtocols = 101,
   HTTPCode102Processing = 102,
   
   // Success
   HTTPCode2XXSuccessUnknown = 2,
   HTTPCode200OK = 200,
   HTTPCode201Created = 201,
   HTTPCode202Accepted = 202,
   HTTPCode203NonAuthoritativeInformation = 203,
   HTTPCode204NoContent = 204,
   HTTPCode205ResetContent = 205,
   HTTPCode206PartialContent = 206,
   HTTPCode207MultiStatus = 207,
   HTTPCode208AlreadyReported = 208,
   HTTPCode209IMUsed = 209,
   
   // Redirection
   HTTPCode3XXSuccessUnknown = 3,
   HTTPCode300MultipleChoices = 300,
   HTTPCode301MovedPermanently = 301,
   HTTPCode302Found = 302,
   HTTPCode303SeeOther = 303,
   HTTPCode304NotModified = 304,
   HTTPCode305UseProxy = 305,
   HTTPCode306SwitchProxy = 306,
   HTTPCode307TemporaryRedirect = 307,
   HTTPCode308PermanentRedirect = 308,
   
   // Client error
   HTTPCode4XXSuccessUnknown = 4,
   HTTPCode400BadRequest = 400,
   HTTPCode401Unauthorised = 401,
   HTTPCode402PaymentRequired = 402,
   HTTPCode403Forbidden = 403,
   HTTPCode404NotFound = 404,
   HTTPCode405MethodNotAllowed = 405,
   HTTPCode406NotAcceptable = 406,
   HTTPCode407ProxyAuthenticationRequired = 407,
   HTTPCode408RequestTimeout = 408,
   HTTPCode409Conflict = 409,
   HTTPCode410Gone = 410,
   HTTPCode411LengthRequired = 411,
   HTTPCode412PreconditionFailed = 412,
   HTTPCode413RequestEntityTooLarge = 413,
   HTTPCode414RequestURITooLong = 414,
   HTTPCode415UnsupportedMediaType = 415,
   HTTPCode416RequestedRangeNotSatisfiable = 416,
   HTTPCode417ExpectationFailed = 417,
   HTTPCode418IamATeapot = 418,
   HTTPCode419AuthenticationTimeout = 419,
   HTTPCode420MethodFailureSpringFramework = 420,
   HTTPCode420EnhanceYourCalmTwitter = 4200,
   HTTPCode422UnprocessableEntity = 422,
   HTTPCode423Locked = 423,
   HTTPCode424FailedDependency = 424,
   HTTPCode424MethodFailureWebDaw = 4240,
   HTTPCode425UnorderedCollection = 425,
   HTTPCode426UpgradeRequired = 426,
   HTTPCode428PreconditionRequired = 428,
   HTTPCode429TooManyRequests = 429,
   HTTPCode431RequestHeaderFieldsTooLarge = 431,
   HTTPCode444NoResponseNginx = 444,
   HTTPCode449RetryWithMicrosoft = 449,
   HTTPCode450BlockedByWindowsParentalControls = 450,
   HTTPCode451RedirectMicrosoft = 451,
   HTTPCode451UnavailableForLegalReasons = 4510,
   HTTPCode494RequestHeaderTooLargeNginx = 494,
   HTTPCode495CertErrorNginx = 495,
   HTTPCode496NoCertNginx = 496,
   HTTPCode497HTTPToHTTPSNginx = 497,
   HTTPCode499ClientClosedRequestNginx = 499,
   
   // Server error
   HTTPCode5XXSuccessUnknown = 5,
   HTTPCode500InternalServerError = 500,
   HTTPCode501NotImplemented = 501,
   HTTPCode502BadGateway = 502,
   HTTPCode503ServiceUnavailable = 503,
   HTTPCode504GatewayTimeout = 504,
   HTTPCode505HTTPVersionNotSupported = 505,
   HTTPCode506VariantAlsoNegotiates = 506,
   HTTPCode507InsufficientStorage = 507,
   HTTPCode508LoopDetected = 508,
   HTTPCode509BandwidthLimitExceeded = 509,
   HTTPCode510NotExtended = 510,
   HTTPCode511NetworkAuthenticationRequired = 511,
   HTTPCode522ConnectionTimedOut = 522,
   HTTPCode598NetworkReadTimeoutErrorUnknown = 598,
   HTTPCode599NetworkConnectTimeoutErrorUnknown = 599
};

NS_ASSUME_NONNULL_BEGIN

@interface JLHTTPClientResponseStatus : NSObject

@property (nonatomic, strong, readonly) NSString * name;
@property (nonatomic, strong, readonly) NSString * about;
@property (nonatomic, readonly) JLHTTPClientResponseStatusCode code;

- (instancetype) initWithCode:(JLHTTPClientResponseStatusCode) code;

+ (NSString *) nameForCode:(JLHTTPClientResponseStatusCode) code;
+ (NSString *) descriptionForCode:(JLHTTPClientResponseStatusCode) code;

@end

NS_ASSUME_NONNULL_END
