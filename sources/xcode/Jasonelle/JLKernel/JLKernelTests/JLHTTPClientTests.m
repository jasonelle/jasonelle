//
//  JLHTTPClientTests.m
//  JLKernelTests
//
//  Created by clsource on 03-02-22
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

#import <XCTest/XCTest.h>
#import <JLKernel/JLKernel.h>

static NSString * const TestAPIURL = @"https://jsonplaceholder.typicode.com/todos/1";

@interface JLHTTPClientTests : XCTestCase

@end

@implementation JLHTTPClientTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testThatGETWorks {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Test GET Request"];

    JLHTTPClientRequest *request = [[JLHTTPClientRequest alloc] initWithURL:TestAPIURL];

    JLHTTPClient *client = [JLHTTPClient new];

    [client fetch:request then:^(JLHTTPClientResponse * _Nonnull response) {
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.data);
        // Test if we can convert the data to string
        [response text:^(NSString * _Nullable body, NSError * _Nonnull error) {
            XCTAssertNotNil(body);
            XCTAssertNil(error);

            // Test if we can convert the data to json dict
            [response json:^(NSDictionary * _Nullable json, NSError * _Nonnull error) {
                XCTAssertNotNil(json);
                XCTAssertNil(error);
                [expectation fulfill];
            }];
        }];
    }];

    (void) [XCTWaiter waitForExpectations:@[expectation] timeout:5];
}

@end
