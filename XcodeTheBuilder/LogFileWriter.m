//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "LogFileWriter.h"
#import "LogFileEntry.h"

@interface LogFileWriter ()
@property(nonatomic, strong) NSDate *buildStartTime;
@property(nonatomic, strong) NSString *logFilePath;
@end

@implementation LogFileWriter

- (instancetype)initWithFilePath:(NSString*)logFileName {
    self = [super init];
    if (self) {
        self.logFilePath = logFileName;
        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }

    return self;
}

- (NSString *)logFile {
    return [NSString stringWithContentsOfFile:self.logFilePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)appendToFile:(NSString *)stringContent {
    NSFileHandle *logFileHandle = [NSFileHandle fileHandleForWritingAtPath:[self logFilePath]];
    if (!logFileHandle) {
        [[NSFileManager defaultManager] createFileAtPath:[self logFilePath] contents:nil attributes:nil];
        logFileHandle = [NSFileHandle fileHandleForWritingAtPath:[self logFilePath]];
    }
    if (!logFileHandle) return;
    @try {
        [logFileHandle seekToEndOfFile];
        [logFileHandle writeData:[stringContent dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (NSException *e) {}
    [logFileHandle closeFile];
}


- (void)buildWillStart {
    self.buildStartTime = [NSDate date];
}

- (void)buildDidStop {
    NSString* buildDateString = [[[LogFileEntry class] parsingDateFormatter] stringFromDate:[NSDate date]];
    [self appendToFile:[NSString stringWithFormat:@"%@,%f\n", buildDateString, [[NSDate date] timeIntervalSinceDate:self.buildStartTime]]];
}

- (void)clearLogFile {
    [[NSFileManager defaultManager] removeItemAtPath:self.logFilePath error:nil];
}
@end