//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LogFileWriter;
@class LogFileParser;


@interface LogFileManager : NSObject

- (instancetype)initWithWriter:(LogFileWriter *)writer parser:(LogFileParser *)parser;

- (NSString *)summary;

- (void)clearBuildHistory;
@end