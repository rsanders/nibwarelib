//
//  NibwareHTMLifier.m
//  pingle
//
//  Created by robertsanders on 1/19/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <math.h>

#import "NibwareHTMLifier.h"

#import "RegexKitLite.h"

@interface NibwareHTMLTextLinkifier : NSObject <NibwareHTMLifierDelegate> {
}
@end

@implementation NibwareHTMLTextLinkifier
- (NSString *) handleURL:(NSString *)url
{
    return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, url];
}
- (NSString *) handleEmailAddress:(NSString *)address
{
    return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", 
            [@"mailto:" stringByAppendingString:address], address];
}
@end

@implementation NibwareHTMLifier

@synthesize delegate, source, destination, urlRegex;

+ (NSString *) linkifyString:(NSString *)string
{
    NibwareHTMLifier *ify = [[NibwareHTMLifier alloc] initWithDelegate:
                                [[[NibwareHTMLTextLinkifier alloc] init] autorelease]];
    NSString *res = [[[ify htmlify:string] retain] autorelease];
    [ify release];
    return res;
}


/*
 * For some URL regexes, see:
 *    http://www.truerwords.net/articles/ut/urlactivation.html
 *    http://www.codinghorror.com/blog/archives/001181.html
 *    http://josephscott.org/archives/2008/11/makeitlink-detecting-urls-in-text-and-making-them-links/
 *
 *
 */

- (NibwareHTMLifier*) initWithDelegate:(id<NibwareHTMLifierDelegate>)del
{
    self = [super init];
    self.delegate = del;
    self.urlRegex = @"\\b(http|https|ftp)://[A-Za-z0-9\\+\\&\\@\\#\\/\\%\\?\\=\\~\\_\\(\\)\\|\\!\\:\\,\\.\\;\\-]*[\\-A-Za-z0-9\\+\\&\\@\\#\\/\\%\\=\\~\\_\\|]";
    return self;
}

- (void) startString:(NSString *)string
{
    self.source = string;
    self.destination = [[NSMutableString alloc] init];
}

- (BOOL) process:(NSError **)errptr
{
    if (!source || ! source.length) {
        return NO;
    }
    NSRange currentRange = NSMakeRange(0, source.length);
    BOOL done = NO;
    while (!done)
    {
        NSError *rError = nil;
        NSRange regexRange = [source rangeOfRegex:urlRegex options:RKLCaseless inRange:currentRange capture:0 error:&rError];
        if (rError) {
            NSLog(@"NibwareHTMLifier: error in regex execution; %@ - %@", rError, [rError userInfo]);
            if (errptr) *errptr = rError;
            break;
        }
        if (regexRange.location == NSNotFound) {
            [destination appendString:[source substringWithRange:currentRange]];
            done = YES;
        } else {
            NSRange midRange = NSMakeRange(currentRange.location, regexRange.location - currentRange.location);
            [destination appendString:[source substringWithRange:midRange]];
            
            [destination appendString:[delegate handleURL:[source substringWithRange:regexRange]]];
            int start = regexRange.location + regexRange.length;
            currentRange = (start >= [source length]) ? 
                            NSMakeRange([source length], 0) :
                            NSMakeRange(start, [source length] - start);
        }
        
        if (currentRange.length <= 0 || currentRange.location > [source length]) {
            done = YES;
        }
    }
    return done;
}

- (NSString *) htmlify:(NSString *)string
{
    [self startString:string];
    [self process:nil];
    
    return destination;
}

- (void) dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
