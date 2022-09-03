//
//  JLUtilsJSON.m
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

#import "JLUtilsJSON.h"

@implementation JLUtilsJSON

- (id)decode:(NSString *)string {
    NSError *error;

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    id json;

    if (@available(iOS 15.0, *)) {
        jlog_trace(@"JSON5 Allowed (iOS >= 15)");
        json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingJSON5Allowed | NSJSONReadingFragmentsAllowed) error:&error];
    }
    else {
        jlog_trace(@"JSON5 Not Available");
        json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingFragmentsAllowed) error:&error];
    }

    if (!json || error) {
        jlog_trace_join(@"JSON Input: ", string);
        jlog_trace_join(@"JSON Object: ", json);

        if (error) {
            jlog_warning_join(@"Error Decoding to JSON ", error.description);
        }
    }

    return json;
}

- (NSString *)encode:(id)object {
    NSError *error;

    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:(NSJSONWritingFragmentsAllowed | NSJSONWritingSortedKeys) error:&error];

    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (!json || error) {
        jlog_trace_join(@"JSON: ", json);

        if (error) {
            jlog_warning_join(@"Error Encoding to JSON ", error.description);
        }
    }

    return json;
}

@end
