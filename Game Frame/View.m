//
//  View.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "View.h"

#define kSize 16
#define kScale 0.75
#define kScaleWithoutBackground 0.95
#define kBackgroundGridSize 740
#define kBackgroundCenterX 977
#define kBackgroundCenterY 524

@implementation View

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showBackground = YES;
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

- (float)getScale {
    return self.showBackground ? kScale : kScaleWithoutBackground;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    if (self.showBackground) {
        [self drawBackground:dirtyRect];
    }
    [self drawLights:dirtyRect];
}

- (void)drawBackground:(NSRect)dirtyRect {
    int ww = self.bounds.size.width;
    int wh = self.bounds.size.height;
    int frameSize = MIN(ww, wh) * [self getScale];
    frameSize /= kSize;
    frameSize *= kSize;
    float scale = 1.0 * frameSize / kBackgroundGridSize;
    NSSize size = self.background.size;
    int dx = size.width / 2 - kBackgroundCenterX;
    int dy = size.height / 2 - kBackgroundCenterY;
    int x = ww / 2 - scale * size.width / 2 + scale * dx;
    int y = wh / 2 - scale * size.height / 2 + scale * dy;
    int w = scale * size.width;
    int h = scale * size.height;
    NSRect rect = NSMakeRect(x, y, w, h);
    [self.background drawInRect:rect];
}

- (void)drawLights:(NSRect)dirtyRect {
    NSBitmapImageRep *bitmap = self.bitmap;
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    int size = MIN(w, h) * [self getScale] / kSize;
    int ox = (w - size * kSize) / 2;
    int oy = (h - size * kSize) / 2;
    for (int i = 0; i < kSize; i++) {
        for (int j = 0; j < kSize; j++) {
            int x = ox + i * size;
            int y = oy + j * size;
            NSRect rect = NSMakeRect(x, y, size, size);
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
