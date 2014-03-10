//
//  Watcher.m
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import "Watcher.h"
#import "WindowController.h"

void fileChanged(ConstFSEventStreamRef stream, void *arg, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    [WindowController refreshAll];
}

@implementation Watcher

- (id)init {
    self = [super init];
    if (self) {
        self.paths = [[NSMutableSet alloc] init];
        self.stream = NULL;
    }
    return self;
}

- (void)watchFile:(NSString *)filename {
    NSString *path = [filename stringByDeletingLastPathComponent];
    if (![self.paths containsObject:path]) {
        [self.paths addObject:path];
        [self updateStream];
    }
}

- (void)unwatchFile:(NSString *)filename {
    NSString *path = [filename stringByDeletingLastPathComponent];
    if ([self.paths containsObject:path]) {
        [self.paths removeObject:path];
        [self updateStream];
    }
}

- (void)updateStream {
    FSEventStreamRef stream = self.stream;
    if (stream != NULL) {
        FSEventStreamStop(stream);
        FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    NSArray *paths = [self.paths allObjects];
    if (paths.count) {
        NSTimeInterval latency = 1.0;
        stream = FSEventStreamCreate(NULL, &fileChanged, NULL, (__bridge CFArrayRef)paths, kFSEventStreamEventIdSinceNow, (CFAbsoluteTime)latency, kFSEventStreamCreateFlagUseCFTypes);
        FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        FSEventStreamStart(stream);
        self.stream = stream;
    }
    else {
        self.stream = NULL;
    }
}

@end
