//
//  NibwareURLShortener.m
//  pingle
//
//  Created by robertsanders on 5/4/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareURLShortener.h"

#import "NibwareUrlUtils.h"

@implementation NibwareURLShortener

@synthesize longString, shortString;

- (NibwareURLShortener*) initWithURLString:(NSString*)string
{
    if (self = [super init]) {
        longString = [string retain];
    }
    return self;
}


- (NSString*) shorten
{
    NSString *newURLString = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@", 
                              [NibwareUrlUtils urlencode:longString]];
    NSURL *newURL = [NSURL URLWithString:newURLString];
    
    NSError *err = nil;
    longString = [[NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:&err] retain];
    if(!longString || err){
        longString = [shortString retain];
    }
    
    return [[longString retain] autorelease];;
}

- (void) dealloc
{
    [longString release];
    [shortString release];
    [super dealloc];
}

@end
