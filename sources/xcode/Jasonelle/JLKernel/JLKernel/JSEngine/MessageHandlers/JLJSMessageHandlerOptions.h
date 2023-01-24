//
//  JLJSMessageHandlerOptions.h
//  JLKernel
//
//  Created by Camilo Castro on 24-01-23.
//  Copyright © 2023 Jasonelle.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JLKernel/JLJSParams.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLJSMessageHandlerOptions : NSObject

@property (nonatomic, strong) id value;

- (instancetype) initWithValue: (id) value;

- (NSNumber *) toNumber;
- (NSString *) toString;
- (NSDictionary *) toDictionary;
- (NSArray *) toArray;
- (BOOL) toBoolean;
- (JLJSParams *) toParams;

@end

NS_ASSUME_NONNULL_END
