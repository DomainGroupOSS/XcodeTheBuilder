//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LogFileWriter : NSObject

- (instancetype)initWithFilePath:(NSString *)logFileName;

- (NSString *)logFile;

- (void)buildWillStart;

- (void)buildDidStop;

- (void)clearLogFile;
@end