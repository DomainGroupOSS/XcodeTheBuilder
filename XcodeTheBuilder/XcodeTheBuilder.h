//
//  XcodeTheBuilder.h
//  XcodeTheBuilder
//
//  Created by Wojciech Kozlowski on 7/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XcodeTheBuilder;

static XcodeTheBuilder *sharedPlugin;

@interface XcodeTheBuilder : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end