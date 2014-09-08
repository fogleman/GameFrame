//
//  Util.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSImage *)generateStrip:(NSURL *)url {
    NSSet *extensions = [NSSet setWithObjects:@"bmp", @"png", @"gif", nil];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:url.path error:nil];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in files) {
        if ([extensions containsObject:file.pathExtension]) {
            [images addObject:[url URLByAppendingPathComponent:file]];
        }
    }
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:16 pixelsHigh:16 * images.count bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    for (int i = 0; i < images.count; i++) {
        NSImage *frame = [[NSImage alloc] initWithContentsOfURL:[images objectAtIndex:i]];
        [frame drawAtPoint:NSMakePoint(0, i * 16) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    [NSGraphicsContext restoreGraphicsState];
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(16, 16 * images.count)];
    [image addRepresentation:rep];
    return image;
}

+ (NSBitmapImageRep *)loadImage:(NSURL *)url {
    NSImage *image;
    if ([Util isDirectory:url]) {
        image = [Util generateStrip:url];
    }
    else {
        image = [[NSImage alloc] initWithContentsOfURL:url];
    }
    CGImageRef cgImage = [image CGImageForProposedRect:nil context:nil hints:nil];
    return [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
}

+ (BOOL)isDirectory:(NSURL *)url {
    NSNumber *isDirectory;
    BOOL success = [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    return success && [isDirectory boolValue];
}

@end
