//
//  WindowController.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "WindowController.h"
#import "Util.h"

@implementation WindowController

+ (NSMutableArray *)instances {
    static NSMutableArray *instances = nil;
    if (instances == nil) {
        instances = [[NSMutableArray alloc] init];
    }
    return instances;
}

+ (Watcher *)watcher {
    static Watcher *watcher = nil;
    if (watcher == nil) {
        watcher = [[Watcher alloc] init];
    }
    return watcher;
}

+ (void)refreshAll {
    for (WindowController *controller in WindowController.instances) {
        [controller refresh];
    }
}

- (id)initWithFile:(NSString *)filename {
    self = [super initWithWindowNibName:@"Window"];
    if (self) {
        [WindowController.instances addObject:self];
        self.filename = filename;
        self.window.delegate = self;
        [self refresh];
        [WindowController.watcher watchFile:filename];
    }
    return self;
}

- (void)refresh {
    self.view.bitmap = [Util loadImage:self.filename];
    [self.view setNeedsDisplay:YES];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)windowWillClose:(NSNotification *)notification {
    [WindowController.instances removeObject:self];
}

@end
