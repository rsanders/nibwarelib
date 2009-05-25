//
//  NWMappedFileString.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NWMappedFileString.h"


@implementation NWMappedFileString

@synthesize mappedData = _mappedData;

+ (NWMappedFileString*) stringWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod
{
    return [[[NWMappedFileString alloc] initWithPath:path encoding:encoding deleteWhenDone:dod] autorelease];

}

+ (NWMappedFileString*) stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
    return [[[NWMappedFileString alloc] initWithData:data encoding:encoding] autorelease];
}

- (id) initWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
    if (self = [super initWithBytesNoCopy:(void*)[data bytes] 
                                   length:[data length] 
                                 encoding:encoding 
                             freeWhenDone:NO])
    {
        _mappedData = [data retain];
    }
    return self;
}

- (id) initWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod
{
    return [self initWithData:[NWMappedFileData dataWithPath:path deleteWhenDone:dod] encoding:encoding];
}

- (void) dealloc
{
    [_mappedData release];
    [super dealloc];
}

@end
