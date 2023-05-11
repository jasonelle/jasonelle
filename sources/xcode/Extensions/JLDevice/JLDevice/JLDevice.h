//
//  JLDevice.h
//  JLDevice
//
//  Created by clsource on 11-05-23.
//

#import <Foundation/Foundation.h>

//! Project version number for JLDevice.
FOUNDATION_EXPORT double JLDeviceVersionNumber;

//! Project version string for JLDevice.
FOUNDATION_EXPORT const unsigned char JLDeviceVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JLDevice/PublicHeader.h>

#import <JLKernel/JLKernel.h>
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface JLDevice : JLExtension

@end

NS_ASSUME_NONNULL_END
