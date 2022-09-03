//
//  JLLogLevel.m
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

#import "JLLogLevel.h"

JLLogLabel const JLLogLabelTrace = @"Trace";
JLLogLabel const JLLogLabelDebug = @"Debug";
JLLogLabel const JLLogLabelInfo = @"Info";
JLLogLabel const JLLogLabelNotice = @"Notice";
JLLogLabel const JLLogLabelWarning = @"Warning";
JLLogLabel const JLLogLabelError = @"Error";
JLLogLabel const JLLogLabelCritical = @"Critical";
JLLogLabel const JLLogLabelDisabled = @"Disabled";

@implementation JLLogLevel

- (BOOL)compare:(nonnull JLLogLevel *)level {
    return self.severity < level.severity;
}

@end
