//
//  JLUtilsJSON.h
//  JLKernel
//
//  Created by clsource on 05-05-22
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
#import <JLKernel/JLUtil.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLUtilsJSON : JLUtil

- (nullable id)decode:(NSString *)string;
- (nullable NSString *)encode:(id)object;

@end

NS_ASSUME_NONNULL_END
