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

+ (Watcher *)sharedWatcher {
    static Watcher *watcher = nil;
    if (watcher == nil) {
        watcher = [[Watcher alloc] init];
    }
    return watcher;
}

- (id)init {
    self = [super init];
    if (self) {
        self.subscriptions = [[NSMutableDictionary alloc] init];
        self.stream = NULL;
    }
    return self;
}

- (void)watchFile:(NSString *)filename {
    NSString *path = [filename stringByDeletingLastPathComponent];
    if ([self.subscriptions objectForKey:path] == nil) {
        [self.subscriptions setObject:@(1) forKey:path];
        [self updateStream];
    }
    else {
        int value = [[self.subscriptions objectForKey:path] intValue] + 1;
        [self.subscriptions setObject:@(value) forKey:path];
    }
}

- (void)unwatchFile:(NSString *)filename {
    NSString *path = [filename stringByDeletingLastPathComponent];
    if ([self.subscriptions objectForKey:path] == nil) {
        // do nothing
    }
    else {
        int value = [[self.subscriptions objectForKey:path] intValue] - 1;
        if (value > 0) {
            [self.subscriptions setObject:@(value) forKey:path];
        }
        else {
            [self.subscriptions removeObjectForKey:path];
            [self updateStream];
        }
    }
}

- (void)updateStream {
    FSEventStreamRef stream = self.stream;
    if (stream != NULL) {
        FSEventStreamStop(stream);
        FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    NSArray *paths = [self.subscriptions allKeys];
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
