//
//  Util.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSBitmapImageRep *)loadImage:(NSString *)filename {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:filename];
    CGImageRef cgImage = [image CGImageForProposedRect:nil context:nil hints:nil];
    return [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
}

@end
