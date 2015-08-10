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

+ (NSDateFormatter*) parsingDateFormatter{
    static NSDateFormatter *parsingDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parsingDateFormatter = [[NSDateFormatter alloc] init];
        [parsingDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [parsingDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return parsingDateFormatter;
}

+ (NSDateFormatter*) dayDateFormatter{
    static NSDateFormatter *dayDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dayDateFormatter = [[NSDateFormatter alloc] init];
        [dayDateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dayDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return dayDateFormatter;
}

+ (NSNumberFormatter *) numberFormatter{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    return numberFormatter;
}

- (NSDate *)buildDay {
    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
              fromDate:self.buildDate];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSString *)buildDayString {
    return [[[self class] dayDateFormatter] stringFromDate:self.buildDay];
}

+ (instancetype)entryWithBuildDate:(NSDate *)buildDate buildTime:(NSTimeInterval)buildTime {
    return [[self alloc] initWithBuildDate:buildDate buildTime:buildTime];
}

- (NSString *)buildTimeString {
    NSDate *buildDate = [NSDate dateWithTimeIntervalSince1970:self.buildTime];
    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
              fromDate:buildDate];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    return [NSString stringWithFormat:@"%@ - %dh %dm %ds", [self buildDayString], (int) [components hour], (int) [components minute], (int) [components second]];
}

+ (instancetype)entryWithBuildDateString:(NSString *)buildDateString buildTimeString:(NSString *)buildTimeString {
    NSDate *buildDate = [[[self class] parsingDateFormatter] dateFromString:buildDateString];
    NSNumber *buildTime = [[[self class] numberFormatter] numberFromString:buildTimeString];

    return [[self alloc] initWithBuildDate:buildDate buildTime:[buildTime doubleValue]];
}

@end