//
//  JLLogLevel.h
//  JLKernel
//
//  Created by clsource on 02-02-22
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

typedef NS_ENUM(NSUInteger, JLLogSeverity) {
    JLLogSeverityTrace,
    JLLogSeverityDebug,
    JLLogSeverityInfo,
    JLLogSeverityNotice,
    JLLogSeverityWarning,
    JLLogSeverityError,
    JLLogSeverityCritical,
    // No level is above this
    // Disables all logging
    JLLogSeverityDisabled
};

typedef NSString * JLLogLabel NS_TYPED_ENUM;
extern JLLogLabel const JLLogLabelTrace;
extern JLLogLabel const JLLogLabelDebug;
extern JLLogLabel const JLLogLabelInfo;
extern JLLogLabel const JLLogLabelNotice;
extern JLLogLabel const JLLogLabelWarning;
extern JLLogLabel const JLLogLabelError;
extern JLLogLabel const JLLogLabelCritical;
extern JLLogLabel const JLLogLabelDisabled;

@interface JLLogLevel : NSObject

@property (nonatomic, strong, nonnull) NSString * label;
@property (nonatomic) JLLogSeverity severity;

/// Returns `false` if the level is less than the parameter
- (BOOL) compare: (nonnull JLLogLevel *) level;

@end

NS_ASSUME_NONNULL_END
