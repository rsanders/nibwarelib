//
//  NibwareIOBase.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareIOBase.h"

@implementation NibwareIOException
@end

@implementation NWTempFileHandle

@synthesize path = _path, deleteWhenDone = _deleteWhenDone;

+ (NWTempFileHandle*) handleWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    return [[[NWTempFileHandle alloc] initWithPath:path deleteWhenDone:dod] autorelease];
}

+ (NWTempFileHandle*) handleWithPath:(NSString*)path
{
    return [NWTempFileHandle handleWithPath:path deleteWhenDone:YES];
}

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    if (self = [super init]) {
        _path = [path retain];
        _deleteWhenDone = dod;
    }
    return self;
}

- (void) dealloc {
    if (_path && _deleteWhenDone) {
        [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
    }
    [_path release];
    [super dealloc];
}
