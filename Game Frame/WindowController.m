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

+ (void)refreshAll {
    for (WindowController *controller in WindowController.instances) {
        [controller refresh];
    }
}

+ (void)updateAll {
    for (WindowController *controller in WindowController.instances) {
        [controller update];
    }
}

- (id)initWithURL:(NSURL *)url {
    self = [super initWithWindowNibName:@"Window"];
    if (self) {
        [WindowController.instances addObject:self];
        self.url = url;
        [self.window setTitleWithRepresentedFilename:url.path];
        self.window.delegate = self;
        [self refresh];
        [[Watcher sharedWatcher] watchFile:url];
    }
    return self;
}

- (void)refresh {
    self.view.bitmap = [Util loadImage:self.url];
    [self.view setNeedsDisplay:YES];
}

- (void)update {
    [self.view update];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)windowWillClose:(NSNotification *)notification {
    [[Watcher sharedWatcher] unwatchFile:self.url];
    [WindowController.instances removeObject:self];
}

@end
