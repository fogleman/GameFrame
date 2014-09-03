//
//  Watcher.h
//  Game Frame
//
//  Created by Michael Fogleman on 3/9/14.
//  Copyright (c) 2014 Michael Fogleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreServices/CoreServices.h>

@interface Watcher : NSObject

+ (Watcher *)sharedWatcher;

- (id)init;
- (void)watchFile:(NSURL *)url;
- (void)unwatchFile:(NSURL *)url;

@property (strong) NSMutableDictionary *subscriptions;
@property (assign) FSEventStreamRef stream;

@end
