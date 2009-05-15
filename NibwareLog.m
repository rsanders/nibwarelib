//
//  NibwareLog.m
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareLog.h"

#undef NSLog

@implementation NibwareLog

@synthesize maxMessages, messages, doNotify, doArchive;

#pragma mark Overhead methods 

+ (NibwareLog *) singleton {
    static NibwareLog *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[NibwareLog alloc] init];
        
        return sharedSingleton;
    }
    
    // shutup Xcode
    return sharedSingleton;
}

- (NibwareLog *) init {
    [super init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(lowmemNotification:) 
                   name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    self.messages = [[NSMutableArray alloc] init];
    self.doNotify = NO;
    self.doArchive = NO;
    
    return self;
}

- (void) dealloc {
    self.messages = Nil;

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    [super dealloc];
}

#pragma mark maintenance

- (void) lowmemNotification:(NSNotification*)notification
{
    [self.messages removeAllObjects];
}

#pragma mark Useful Methods

- (void) log:(NSString *)message {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (doArchive) {
        @synchronized (messages)
        {
            [[self messages] addObject:message];
        }
    }
    NSLog(message);
    
    if (doNotify) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        [center postNotificationName:NIBWARE_NOTIFICATION_LOG  object:self userInfo:userInfo];
    }
    
    [pool release];
}

- (void) logWithFormat:(NSString *)format, ... {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    va_list ap;
    
    va_start(ap, format);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    [self log:result];
    [result release];
    [pool release];
}


- (void) logWithFormat:(NSString *)format arguments:(va_list) arguments {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *result = [[NSString alloc] initWithFormat:format arguments:arguments];
    [self log:result];
    [result release];
    
    [pool release];
}

@end

void NWLog(NSString *format, ...)
{
    va_list ap;

    NSString *format2 = [@"%s: " stringByAppendingString:format];
    
    va_start(ap, format);
    [[NibwareLog singleton] logWithFormat:format2 arguments:ap];
    va_end(ap);
}

void NullLog(NSString *format, ...)
{
    // do nothing
}
