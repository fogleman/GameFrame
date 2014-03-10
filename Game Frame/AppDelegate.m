//
//  AppDelegate.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (WindowController.instances.count == 0) {
        [self openDocument:nil];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

- (void)openFile:(NSString *)filename {
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:filename]];
    WindowController *controller = [[WindowController alloc] initWithFile:filename];
    [controller showWindow:nil];
}

- (void)openDocument:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.title = @"Open";
    panel.showsResizeIndicator = YES;
    panel.showsHiddenFiles = NO;
    panel.canChooseDirectories = NO;
    panel.canCreateDirectories = YES;
    panel.allowsMultipleSelection = YES;
    panel.allowedFileTypes = @[@"bmp", @"png"];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            for (NSURL *url in panel.URLs) {
                NSString *filename = [url.path stringByResolvingSymlinksInPath];
                [self openFile:filename];
            }
        }
    }];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    [self openFile:filename];
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    for (NSString *filename in filenames) {
        [self openFile:filename];
    }
}

@end
