//
//  NibwareLog.h
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NibwareLog : NSObject {
    NSMutableArray *messages;
    NSInteger maxMessages;
    
    BOOL doNotify;
}

+ (NibwareLog *)singleton;

- (void) log:(NSString *)message;
- (void) logWithFormat:(NSString *)message, ...;
- (void) logWithFormat:(NSString *)message arguments:(va_list)args;

@property (retain) NSMutableArray *messages;
@property (assign) NSInteger maxMessages;
@property (assign) BOOL doNotify;

@end

void NWLog(NSString *format, ...);
void NullLog(NSString *format, ...);

#define NIBWARE_NOTIFICATION_LOG @"log_message"

#ifndef LEAVE_NSLOG_ALONE
#define OriginalNSLog  NSLog
#define NSLog          NWLog
#endif