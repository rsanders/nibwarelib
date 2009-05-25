//
//  NWMappedFileData.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareIOBase.h"
#import "NWMappedFileData.h"
#import "NWSubrangeReferenceData.h"


@implementation NWMappedFileData

@synthesize deleteWhenDone = _deleteWhenDone, path = _path, tempHandle = _tempHandle;

+ (NSData*) dataWithTempFileHandle:(NWTempFileHandle*)handle
{
    return [[[NWMappedFileData alloc] initWithTempFileHandle:handle] autorelease];
}

+ (NSData*) dataWithTempFileHandle:(NWTempFileHandle*)handle range:(NSRange)range
{
    NSData *base = (NSData*)[[self class] dataWithTempFileHandle:handle];
    return [NWSubrangeReferenceData dataWithData:base range:range];
}

+ (NSData*) dataWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    return (NSData*)[[[NWMappedFileData alloc] initWithPath:path deleteWhenDone:dod] autorelease];
}

+ (NSData*) dataWithPath:(NSString*)path range:(NSRange)range deleteWhenDone:(BOOL)dod
{
    NSData *base = (NSData*)[[self class] dataWithPath:path deleteWhenDone:dod];
    return [NWSubrangeReferenceData dataWithData:base range:range];
}

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod
{
    return [self initWithTempFileHandle:[NWTempFileHandle handleWithPath:path deleteWhenDone:dod]];
}

- (id) initWithTempFileHandle:(NWTempFileHandle*)handle
{
    _path = [[handle path] retain];
    _deleteWhenDone = handle.deleteWhenDone;
    _tempHandle = [handle retain];
    _realData = [[NSData dataWithContentsOfMappedFile:_path] retain];
    
    return self;
}

#pragma mark Proxying to data

+ (BOOL)isSubclassOfClass:(Class)aClass
{
    return [aClass isEqual:[NSData class]];
}

+ (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [self conformsToProtocol:aProtocol] || [NSData conformsToProtocol:aProtocol];
}

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

#pragma mark copying

- (id) copyWithZone:(NSZone*)zone
{
    return [[[self class] alloc] initWithTempFileHandle:_tempHandle];
}

- (id) mutableCopyWithZone:(NSZone*)zone
{
    return [[NSMutableData dataWithData:(NSData*)self] retain];
}

#pragma mark cleanup

- (void) dealloc
{
    [_realData release];
    [_tempHandle release];
    [_path release];
    [super dealloc];
}

@end
