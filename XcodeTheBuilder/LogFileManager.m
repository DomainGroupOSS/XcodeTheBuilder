//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "LogFileManager.h"

static NSString *const logFileName = @"timeLogFile.txt";

@interface LogFileManager ()
@property(nonatomic, strong) NSDate *buildStartTime;
@property(nonatomic, strong) NSString *documentsPath;
@property(nonatomic, strong) NSString *logFilePath;
@end

@implementation LogFileManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.documentsPath = [self findDocumentsPath];
        self.logFilePath = [self.documentsPath stringByAppendingPathComponent:logFileName];
    }

    return self;
}

- (NSString *)findDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
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


- (void)buildStarted {
    self.buildStartTime = [NSDate date];
}

- (void)buildFinished {
    [self appendToFile:[NSString stringWithFormat:@"%@,%f\n", [NSDate date], [[NSDate date] timeIntervalSinceDate:self.buildStartTime]]];
}
@end