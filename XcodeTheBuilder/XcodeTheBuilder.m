//
//  XcodeTheBuilder.m
//  XcodeTheBuilder
//
//  Created by Wojciech Kozlowski on 7/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "XcodeTheBuilder.h"
#import "LogFileWriter.h"
#import "LogFileManager.h"
#import "LogFileParser.h"

static NSString *const str = @"xcodeTheBuilder.log";

@interface XcodeTheBuilder ()
@property(nonatomic, strong) LogFileManager *logFileManager;
@end

@implementation XcodeTheBuilder

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)init {
    if (self = [super init]) {
        self.logFileManager = [[LogFileManager alloc] initWithWriter:[self createWriter] parser:[LogFileParser new]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (LogFileWriter *)createWriter {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsPath =  paths[0];
    NSString* fullFilePath = [documentsPath stringByAppendingPathComponent:str];
    return [[LogFileWriter alloc] initWithFilePath:fullFilePath];
}


- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    [self addTotalBuildTimeItem];
}

- (void)addTotalBuildTimeItem {
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *totalBuildTime = [[NSMenuItem alloc] initWithTitle:@"Total Build Time" action:@selector(showTotalBuildTime) keyEquivalent:@""];
        [totalBuildTime setTarget:self];
        [[menuItem submenu] addItem:totalBuildTime];

        NSMenuItem *resetBuildTime = [[NSMenuItem alloc] initWithTitle:@"Clear Build Time History" action:@selector(clearTotalBuildTime) keyEquivalent:@""];
        [resetBuildTime setTarget:self];
        [[menuItem submenu] addItem:resetBuildTime];
    }
}

- (void)clearTotalBuildTime {
    [self.logFileManager clearBuildHistory];
}

- (void)showTotalBuildTime {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[self.logFileManager summary]];
    [alert runModal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
