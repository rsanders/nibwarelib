//
//  NWMappedFileData.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NWMappedFileData.h"


@implementation NWMappedFileData

@synthesize deleteWhenDone = _deleteWhenDone, path = _path;

+ (NWMappedFileData*) dataWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    return [[[NWMappedFileData alloc] initWithPath:path deleteWhenDone:dod] autorelease];
}

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    if (self = [super initWithContentsOfMappedFile:path]) {
        _path = [path retain];
        _deleteWhenDone = dod;
    }
    return self;
}

- (void) dealloc
{
    if (_deleteWhenDone && _path) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:_path error:&err];
    }

    [_path release];
    [super dealloc];
}

@end
