//
//  JLApplicationHTTP.h
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
#import <JLKernel/JLHTTPAdapterProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplicationHTTP : NSObject
@property (nonatomic, strong, nonnull) id<JLHTTPAdapterProtocol> adapter;
@end

NS_ASSUME_NONNULL_END
