//
//  JLRendererProtocol.h
//  JLKernel
//
//  Created by clsource on 06-02-22
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

NS_ASSUME_NONNULL_BEGIN

/// This protocol provides common methods and properties for view renderers
@protocol JLRendererProtocol<NSObject>

/// The main view object associated with this renderer
@property (nonatomic, strong, nullable) id view;

@end

NS_ASSUME_NONNULL_END
