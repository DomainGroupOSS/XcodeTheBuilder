//
//  XcodeTheBuilder.m
//  XcodeTheBuilder
//
//  Created by Wojciech Kozlowski on 7/08/2015.
//  Copyright (c) 2015 Wojciech Kozlowski. All rights reserved.
//

#import "XcodeTheBuilder.h"
#import "LogFileManager.h"

@interface XcodeTheBuilder ()
@property(nonatomic, strong, readwrite) NSBundle *bundle;
@property(nonatomic, strong) LogFileManager *logFileManager;
@end

@implementation XcodeTheBuilder

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;
        self.logFileManager = [LogFileManager new];
        [self addListeners];
    }
    return self;
}

- (void)addListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didApplicationFinishLaunchingNotification:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildWillStart:) name:@"IDEBuildOperationWillStartNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildDidStop:) name:@"IDEBuildOperationDidStopNotification" object:nil];
}


- (void)buildWillStart:(NSNotification *)notification {
    [self.logFileManager buildStarted];
}

- (void)buildDidStop:(NSNotification *)notification {
    [self.logFileManager buildFinished];
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)doMenuAction {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
