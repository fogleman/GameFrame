//
//  View.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "View.h"

#define kSize 16

@implementation View

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mask = [NSImage imageNamed:@"mask"];
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)update {
    int previous = offset;
    offset = (offset + kSize) % self.bitmap.pixelsHigh;
    if (offset != previous) {
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    NSBitmapImageRep *bitmap = self.bitmap;
    if (!bitmap) {
        return;
    }
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    int size = MIN(w, h) * 15 / 16 / kSize;
    int ox = (w - size * kSize) / 2;
    int oy = (h - size * kSize) / 2;
    for (int i = 0; i < kSize; i++) {
        for (int j = 0; j < kSize; j++) {
            int x = ox + i * size;
            int y = oy + j * size;
            CGRect rect = NSMakeRect(x, y, size, size);
            if (!CGRectIntersectsRect(rect, dirtyRect)) {
                continue;
            }
            int px = i;
            int py = j + offset;
            NSColor *color = [bitmap colorAtX:px y:py];
            float brightness = MIN(1.0, color.brightnessComponent * 1.25 + 0.15);
            color = [NSColor colorWithHue:color.hueComponent saturation:color.saturationComponent brightness:brightness alpha:color.alphaComponent];
            [color setFill];
            NSRectFill(rect);
            [self.mask drawInRect:rect];
        }
    }
}

@end
