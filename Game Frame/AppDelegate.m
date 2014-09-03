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

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    if (WindowController.instances.count == 0) {
        [self openDocument:nil];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer {
    [WindowController updateAll];
}

- (IBAction)onShowBackground:(id)sender {
    for (WindowController *controller in WindowController.instances) {
        controller.view.showBackground = !controller.view.showBackground;
        [controller refresh];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

- (void)openFile:(NSURL *)url {
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:url];
    WindowController *controller = [[WindowController alloc] initWithURL:url];
    [controller showWindow:nil];
}

- (void)openDocument:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.title = @"Open";
    panel.showsResizeIndicator = YES;
    panel.showsHiddenFiles = NO;
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = YES;
    panel.allowsMultipleSelection = YES;
    panel.allowedFileTypes = @[@"bmp", @"png", @"gif"];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            for (NSURL *url in panel.URLs) {
                [self openFile:url];
            }
        }
    }];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    [self openFile:[NSURL URLWithString:filename]];
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    for (NSString *filename in filenames) {
        [self openFile:[NSURL URLWithString:filename]];
    }
}

@end
