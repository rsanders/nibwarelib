//
//  NibwareMIMEPart.m
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareMIMEPart.h"


@implementation NibwareMIMEPart

@synthesize body;
@synthesize name;
@synthesize fileName;
@synthesize mimeType;


- (void) dealloc {
    [body release];
    [name release];
    [fileName release];
    [mimeType release];

    [super dealloc];
}

@end
