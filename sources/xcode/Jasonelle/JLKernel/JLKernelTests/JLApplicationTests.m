//
//  JLApplicationTests.m
//  JLKernelTests
//
//  Created by clsource on 03-02-22
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

#import <XCTest/XCTest.h>
#import <JLKernel/JLApplication.h>

@interface JLApplicationTests : XCTestCase

@end

@implementation JLApplicationTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testThatInstanceIsStored {
    JLApplication *app = [JLApplication new];

    [JLApplication setInstance:app];
    NSAssert([app isEqual:[JLApplication instance]], @"Application is not equal to the instance");
    NSAssert([app isEqual:JLApplication.instance], @"Application is not equal to the instance");
}

- (void)testThatLoggerPropertyExists {
    JLApplication *app = [JLApplication new];

    NSAssert([app respondsToSelector:@selector(logger)], @"does not have logger property");
}

@end
