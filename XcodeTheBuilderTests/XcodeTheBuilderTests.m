//
//  XcodeTheBuilderTests.m
//  XcodeTheBuilderTests
//
//  Created by Wojtek Kozlowski on 07/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LogFileParser.h"

@interface XcodeTheBuilderTests : XCTestCase

@end

@implementation XcodeTheBuilderTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    LogFileParser *parser = [LogFileParser new];
    [parser parse:@""

}


@end
