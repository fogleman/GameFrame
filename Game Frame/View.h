//
//  View.h
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface View : NSView {
    int offset;
}

- (void)update;

@property (strong) NSImage *mask;
@property (strong) NSBitmapImageRep *bitmap;

@end
