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

- (id)initWithFile:(NSString *)file;
- (void)refresh;

@property (assign) IBOutlet View *view;
@property (strong) NSString *filename;

@end
