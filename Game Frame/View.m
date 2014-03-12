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
        self.background = [NSImage imageNamed:@"frame"];
        self.mask = [NSImage imageNamed:@"mask"];
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)update {
    if (!self.bitmap) {
        return;
    }
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
    [self drawBackground:dirtyRect];
    [self drawLights:dirtyRect];
}

- (void)drawBackground:(NSRect)dirtyRect {
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    int size = MIN(w, h);
    int ox = (w - size) / 2;
    int oy = (h - size) / 2;
    CGRect rect = NSMakeRect(ox, oy, size, size);
    [self.background drawInRect:rect];
}

- (void)drawLights:(NSRect)dirtyRect {
    NSBitmapImageRep *bitmap = self.bitmap;
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    int size = MIN(w, h) * 21 / 32 / kSize;
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
            NSColor *color = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1];
            if (bitmap) {
                int px = i;
                int py = j + offset;
                color = [bitmap colorAtX:px y:py];
            }
            float brightness = MIN(1.0, color.brightnessComponent * 1.25 + 0.15);
            color = [NSColor colorWithHue:color.hueComponent saturation:color.saturationComponent brightness:brightness alpha:color.alphaComponent];
            [color setFill];
            NSRectFill(rect);
            [self.mask drawInRect:rect];
        }
    }
}

@end
