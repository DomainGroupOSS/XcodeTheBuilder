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
#import "LogFileWriter.h"
#import "LogFileEntry.h"
#import "LogFileManager.h"

@interface XcodeTheBuilderTests : XCTestCase
@property(nonatomic, strong) LogFileManager *manager;
@end

@implementation XcodeTheBuilderTests

- (void)setUp {
    self.manager = [[LogFileManager alloc] initWithWriter:[LogFileWriter new] parser:[LogFileParser new]];
    [super setUp];
}

- (void)testExample {
    NSString *summary = [self.manager summary];
    XCTAssertNotNil(summary);
}


@end
