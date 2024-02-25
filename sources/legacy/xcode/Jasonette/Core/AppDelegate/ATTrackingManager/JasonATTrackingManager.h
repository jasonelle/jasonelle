//
//  JasonATTrackingManager.h
//  Jasonette
//
//  Created by Jasonelle Team on 17-06-21.
//  Copyright © 2021 Jasonette. All rights reserved.
//
/*
 This file shows the tracking notification in iOS >= 14.5
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JasonATTrackingManager : NSObject

+ (void) showWithSettings: (NSDictionary *) settings;

@end

NS_ASSUME_NONNULL_END
