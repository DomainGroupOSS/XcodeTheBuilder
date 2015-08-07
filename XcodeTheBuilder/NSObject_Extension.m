//
//  NSObject_Extension.m
//  XcodeTheBuilder
//
//  Created by Wojciech Kozlowski on 7/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//


#import "NSObject_Extension.h"
#import "XcodeTheBuilder.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[XcodeTheBuilder alloc] init];
        });
    }
}
@end
