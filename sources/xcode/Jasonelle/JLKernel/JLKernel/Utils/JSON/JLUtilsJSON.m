//
//  JLUtilsJSON.m
//  JLKernel
//
//  Created by clsource on 05-05-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
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

- (BOOL) isValid:(NSString *)string {
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
        if (error) {
            jlog_warning_join(@"Error Decoding to JSON ", error.description);
        }
        return NO;
    }
    
    return YES;
}

- (BOOL) isValidStict:(NSString *) string {
    NSError *error;

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (!json || error) {
        if (error) {
            jlog_warning_join(@"Error Decoding to JSON ", error.description);
        }
        return NO;
    }
    
    return YES;
}

@end
