//
//  WindowController.h
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "View.h"
#import "Watcher.h"

@interface WindowController : NSWindowController <NSWindowDelegate>

+ (NSMutableArray *)instances;
+ (void)refreshAll;
+ (void)updateAll;

- (id)initWithURL:(NSURL *)url;
- (void)refresh;
- (void)update;

@property (assign) IBOutlet View *view;
@property (strong) NSURL *url;

@end
