//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "LogFileEntry.h"


@implementation LogFileEntry

- (instancetype)initWithBuildDate:(NSDate *)buildDate buildTime:(NSTimeInterval)buildTime {
    self = [super init];
    if (self) {
        _buildDate = buildDate;
        _buildTime = buildTime;
    }

    return self;
}

- (NSDate *)buildDay {
    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
              fromDate:self.buildDate];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSString *)buildDayString {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:self.buildDay];
}

+ (instancetype)entryWithBuildDate:(NSDate *)buildDate buildTime:(NSTimeInterval)buildTime {
    return [[self alloc] initWithBuildDate:buildDate buildTime:buildTime];
}

- (NSString *)buildTimeString {
    NSDate *buildDate = [NSDate dateWithTimeIntervalSince1970:self.buildTime];
    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
              fromDate:buildDate];
    return [NSString stringWithFormat:@"%@ - %dh %dm %ds", [self buildDayString], (int) [components hour], (int) [components minute], (int) [components second]];
}

+ (instancetype)entryWithBuildDateString:(NSString *)buildDateString buildTimeString:(NSString *)buildTimeString {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *buildDate = [df dateFromString:buildDateString];

    NSNumberFormatter *nf = [NSNumberFormatter new];
    NSNumber *buildTime = [nf numberFromString:buildTimeString];

    return [[self alloc] initWithBuildDate:buildDate buildTime:[buildTime doubleValue]];
}

@end