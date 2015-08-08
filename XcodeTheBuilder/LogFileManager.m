//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "LogFileManager.h"
#import "LogFileWriter.h"
#import "LogFileParser.h"
#import "LogFileEntry.h"


@interface LogFileManager ()
@property(nonatomic, strong) LogFileWriter *writer;
@property(nonatomic, strong) LogFileParser *parser;
@end

@implementation LogFileManager

- (instancetype)initWithWriter:(LogFileWriter *)writer parser:(LogFileParser *)parser {
    self = [super init];
    if (self) {
        self.writer = writer;
        self.parser = parser;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildWillStart) name:@"IDEBuildOperationWillStartNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildDidStop) name:@"IDEBuildOperationDidStopNotification" object:nil];
    }

    return self;
}

- (void)buildWillStart {
    [self.writer buildWillStart];
}

- (void)buildDidStop {
    [self.writer buildDidStop];
}

- (NSString *)summary {
    NSArray *buildsForDays = [self buildsForDays];

    NSMutableString *summary = [NSMutableString string];

    for (LogFileEntry *entry in buildsForDays) {
        [summary appendString:[NSString stringWithFormat:@"%@\n", [entry buildTimeString]]];
    }

    [summary appendString:[NSString stringWithFormat:@"total build time: %@", [self totalBuildTime:buildsForDays]]];

    return [NSString stringWithString:summary];
}

- (NSArray *)buildsForDays {
    NSString *logFile = [self.writer logFile];
    NSArray *allBuilds = [self.parser parse:logFile];
    NSArray *distinctDays = [allBuilds valueForKeyPath:@"@distinctUnionOfObjects.buildDay"];
    NSArray *buildsForDays = [self buildsForDays:allBuilds distinctDays:distinctDays];
    return buildsForDays;
}

- (NSString *)totalBuildTime:(NSArray *)builds {
    NSInteger totalBuildTime = [[builds valueForKeyPath:@"@sum.buildTime"] intValue];
    NSDate *buildDate = [NSDate dateWithTimeIntervalSince1970:totalBuildTime];
    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
              fromDate:buildDate];
    return [NSString stringWithFormat:@"%dh %dm %ds", (int) [components hour], (int) [components minute], (int) [components second]];
}

- (NSArray *)buildsForDays:(NSArray *)allBuilds distinctDays:(NSArray *)distinctDays {
    NSMutableArray *buildsForDays = [NSMutableArray new];
    for (NSDate *day in distinctDays) {
        LogFileEntry *buildTimeForDay = [self allBuildsForDay:day builds:allBuilds];
        [buildsForDays addObject:buildTimeForDay];
    }
    return [NSArray arrayWithArray:buildsForDays];
}

- (LogFileEntry *)allBuildsForDay:(NSDate *)day builds:(NSArray *)builds {
    NSTimeInterval buildTimeForDay = 0;
    for (LogFileEntry *entry in builds) {
        if ([entry.buildDay isEqualToDate:day]) {
            buildTimeForDay += entry.buildTime;
        }
    }
    return [LogFileEntry entryWithBuildDate:day buildTime:buildTimeForDay];
}

- (void)clearBuildHistory {
    [self.writer clearLogFile];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end