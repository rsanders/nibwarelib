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

@synthesize maxMessages, messages, doNotify;

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
    self.messages = [[NSMutableArray alloc] init];
    self.doNotify = YES;
    
    return self;
}

- (void) dealloc {
    self.messages = Nil;
    [super dealloc];
}

#pragma mark Useful Methods

- (void) log:(NSString *)message {
    @synchronized (messages)
    {
        [[self messages] addObject:message];
    }
    NSLog(message);
    
    if (doNotify) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        [center postNotificationName:NIBWARE_NOTIFICATION_LOG  object:self userInfo:userInfo];
    }
}

- (void) logWithFormat:(NSString *)format, ... {
    va_list ap;
    
    va_start(ap, format);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    [self log:result];
    [result release];
}


- (void) logWithFormat:(NSString *)format arguments:(va_list) arguments {
    NSString *result = [[NSString alloc] initWithFormat:format arguments:arguments];
    [self log:result];
    [result release];
}

@end

void NWLog(NSString *format, ...)
{
    va_list ap;

    va_start(ap, format);
    [[NibwareLog singleton] logWithFormat:format arguments:ap];
    va_end(ap);
}