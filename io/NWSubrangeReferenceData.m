//
//  NWSubrangeReferenceData.m
//  pingle
//
//  Created by robertsanders on 5/25/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#include <unistd.h>

#import "NWSubrangeReferenceData.h"

static NSInteger counter;

@implementation NWSubrangeReferenceData


@synthesize refData = _refData, range = _range;

+ (void) initialize
{
    counter = time(NULL);
}

+ (NSData*) dataWithData:(NSData*)data range:(NSRange)range
{
    return [[[NWSubrangeReferenceData alloc] initWithData:data range:range] autorelease];
}

+ (NSData*) dataWithData:(NSData*)data
{
    return [[[NWSubrangeReferenceData alloc] initWithData:data] autorelease];
}

- (id) initWithData:(NSData*)data range:(NSRange)range
{
    if (range.location + range.length > data.length) {
        [NibwareIOException raise:@"BadBoundsException" format:@"Data (%d bytes) is not large enough for subrange (%d,%d)",
         data.length, range.location, range.length];
    }

    _refData = [data retain];
    _range = range;
  

    return self;
}

- (id) initWithData:(NSData*)data
{
    return [self initWithData:data range:NSMakeRange(0, data.length)];
}


#pragma mark Ranging of NSData methods

- (NSUInteger)length
{
    return _range.length;
}

- (const void *)bytes
{
    return [_refData bytes] + _range.location;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@ @ %d, %d bytes]", NSStringFromClass([self class]), _range.location, _range.length];
}

- (NSRange) convertRange:(NSRange)range
{
    return NSMakeRange(_range.location + range.location, range.length);
}


- (void)getBytes:(void *)buffer range:(NSRange)range
{
    [_refData getBytes:buffer range:[self convertRange:range]];
}


- (void)getBytes:(void *)buffer
{
    [self getBytes:buffer range:NSMakeRange(0, [self length])];
}

- (void)getBytes:(void *)buffer length:(NSUInteger)length
{
    [self getBytes:buffer range:NSMakeRange(0, length)];
}


- (BOOL)isEqualToData:(NSData *)other
{
    // TODO
    return NO;
}

- (NSData *)subdataWithRange:(NSRange)range
{
    return [_refData subdataWithRange:[self convertRange:range]];
}

- (BOOL)writeToFile:(NSString *)path options:(NSUInteger)writeOptionsMask error:(NSError **)errorPtr
{
    NSString *outFile = path;
    NSString *destFile = nil;
    NSError *error = nil;
    
    if (writeOptionsMask & NSAtomicWrite) {
        destFile = path;
        outFile = [NSString stringWithFormat:@"%@/.data.%d%d.tmp", 
                   [path stringByDeletingLastPathComponent], getpid(), counter++];
    }

    NSFileHandle *handle = nil;
    @try {
        handle = [NSFileHandle fileHandleForWritingAtPath:outFile];

        ssize_t res = write([handle fileDescriptor], [self bytes], [self length]);
        
        if (res == -1) {
            error = [NSError errorWithDomain:@"IOError" code:errno userInfo:
                     [NSDictionary dictionaryWithObject:[NSString stringWithCString:strerror(errno) encoding:NSASCIIStringEncoding]
                                              forKey:NSLocalizedDescriptionKey]];
        } else if (res != [self length]) {
            error = [NSError errorWithDomain:@"IOError" code:0 userInfo:
                     [NSDictionary dictionaryWithObject:NSLocalizedString(@"Short Write", @"Error string")
                                              forKey:NSLocalizedDescriptionKey]];            
        }
        
        [handle closeFile];
        if (res == !error && destFile) {
            [[NSFileManager defaultManager] moveItemAtPath:outFile toPath:destFile error:&error];
        }
    } @catch (NSException *e) {
        if (handle) [handle closeFile];
        // delete temp file
        if (destFile) {
            [[NSFileManager defaultManager] removeItemAtPath:destFile error:nil];
        }
    }
    
    if (errorPtr) *errorPtr = error;
    return error == nil;
}


- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
    return [self writeToFile:path options:(useAuxiliaryFile ? NSAtomicWrite : 0) error:nil];
}


- (BOOL)writeToURL:(NSURL *)url options:(NSUInteger)writeOptionsMask error:(NSError **)errorPtr
{
    if (! [[url scheme] isEqual:@"file"]) {
        [NibwareIOException raise:@"InvalidArgument" format:@"%@ only supports file:// URLs (%@)",
         NSStringFromSelector(_cmd), url];
    }
    return [self writeToFile:[url path] options:writeOptionsMask error:errorPtr];
}


- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically
{
    return [self writeToURL:url options:(atomically ? NSAtomicWrite : 0) error:nil];
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
    [anInvocation setTarget:_refData];
    [anInvocation invoke];
    return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [_refData methodSignatureForSelector:aSelector];
}

- (BOOL) respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || [_refData respondsToSelector:selector];
}

- (BOOL) isKindOfClass:(Class)clazz
{
    return [super isKindOfClass:clazz] || [_refData isKindOfClass:clazz];
}

#pragma mark copying

- (id) copyWithZone:(NSZone*)zone
{
    return [[NWSubrangeReferenceData dataWithData:_refData range:_range] retain];
}

- (id) mutableCopyWithZone:(NSZone*)zone
{
    return [[NSMutableData dataWithData:(NSData*)self] retain];
}

- (NSData*) subDataNoCopy:(NSRange)range
{
    return [NWSubrangeReferenceData dataWithData:_refData 
                                           range:NSMakeRange(_range.location + range.location, range.length)];
}

#pragma mark cleanup

- (void) dealloc
{
    [_refData release];
    [super dealloc];
}

@end


@implementation NSData (NonCopyingSubrange)

- (NSData*) subDataNoCopy:(NSRange)range
{
    return [NWSubrangeReferenceData dataWithData:self range:range];
}

@end