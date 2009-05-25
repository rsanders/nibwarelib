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
    _path = [path retain];
    _deleteWhenDone = dod;

    _realData = [[NSData dataWithContentsOfMappedFile:_path] retain];

    return self;
}

#pragma mark Proxying to data

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation setTarget:_realData];
    [anInvocation invoke];
    return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [_realData methodSignatureForSelector:aSelector];
}

- (BOOL) respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || [_realData respondsToSelector:selector];
}

- (BOOL) isKindOfClass:(Class)clazz
{
    return [super isKindOfClass:clazz] || [_realData isKindOfClass:clazz];
}


#pragma mark cleanup

- (void) dealloc
{
    [_realData release];
    if (_deleteWhenDone && _path) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:_path error:&err];
    }

    [_path release];
    [super dealloc];
}

@end
