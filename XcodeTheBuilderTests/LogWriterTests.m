//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LogFileWriter.h"

@interface LogWriterTests : XCTestCase
@property(nonatomic, copy) NSString *bundleTestFile;
@end

@implementation LogWriterTests

- (void)setUp {
    [super setUp];
    self.bundleTestFile = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"testXcodeTheBuilder.log"];
}

- (void)testReadFile {
    LogFileWriter *logWriter = [[LogFileWriter alloc] initWithFilePath:self.bundleTestFile];
    NSString *logFile = [logWriter logFile];
    XCTAssertNotNil(logFile);
}

- (void)testCreateFile {
    NSString *tempLogFile = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"_tempXcodeTheBuilder.txt"];
    LogFileWriter *logWriter = [[LogFileWriter alloc] initWithFilePath:tempLogFile];
    [logWriter buildWillStart];
    [logWriter buildDidStop];
    XCTAssertNotNil([NSFileHandle fileHandleForReadingAtPath:tempLogFile]);
    NSError *fileRemovalError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:tempLogFile error:&fileRemovalError];
    XCTAssertNil(fileRemovalError);
    XCTAssertNil([NSFileHandle fileHandleForReadingAtPath:tempLogFile]);


}
@end