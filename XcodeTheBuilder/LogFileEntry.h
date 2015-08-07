//
// Created by Wojtek Kozlowski on 07/08/15.
// Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LogFileEntry : NSObject
@property (nonatomic, readonly) NSDate* buildDate;
@property (nonatomic, readonly) NSTimeInterval buildTime;

- (instancetype)initWithBuildDate:(NSDate *)buildDate buildTime:(NSTimeInterval)buildTime;

- (NSDate *)buildDay;

- (NSString *)buildTimeString;

+ (instancetype)entryWithBuildDate:(NSDate *)buildDate buildTime:(NSTimeInterval)buildTime;

+ (instancetype)entryWithBuildDateString:(NSString *)buildDate buildTimeString:(NSString *)buildTime;
@end