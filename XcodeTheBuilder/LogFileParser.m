//
//  LogFileParser.m
//  XcodeTheBuilder
//
//  Created by Wojtek Kozlowski on 07/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "LogFileParser.h"
#import "LogFileEntry.h"

@implementation LogFileParser

- (NSArray *)parse:(NSString *)logFile {
    NSMutableArray *logEntries = [NSMutableArray array];

    NSArray *lines = [logFile componentsSeparatedByString:@"\n"];

    for (NSString *line in lines) {
        NSArray *logComponents = [line componentsSeparatedByString:@","];
        if (logComponents.count == 2) {
            [logEntries addObject:[LogFileEntry entryWithBuildDateString:logComponents[0] buildTimeString:logComponents[1]]];
        }
    }

    return logEntries;
}
@end
