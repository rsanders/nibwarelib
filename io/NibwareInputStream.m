//
//  NibwareInputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareBase.h"
#import "NibwareInputStream.h"

@implementation NibwareInputStreamException
@end

@implementation NibwareBaseInputStream

- (id) init
{
    self = [super init];
    
    _buffer = [[NSMutableData alloc] init];
    
    return self;
}

- (NSData*) readData:(NSUInteger)length
{
    [NibwareInputStreamException raise:@"Unimplemented" format:@"Not implemented"];
    return nil;
}

- (NSUInteger) readBytes:(const void*)bytes length:(NSUInteger)length
{
    NSData *data = [self readData:length];
    [data getBytes:(void*)bytes length:fmin(length, [data length])];
    return [data length];
}

- (NSString*) readString:(NSString*)string length:(NSInteger)length encoding:(NSStringEncoding)encoding
{
    NSData *data = [self readData:length];
    return [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
}

- (id<NSCoding>) readObject
{
    [NibwareInputStreamException raise:@"Unimplemented" format:@"readObject is not implemented"];
    return nil;
}

// may return -1 if unknown or unknowable
- (NSInteger) size
{
    return -1;
}

- (NSInteger) remainingBytes
{
    return -1;
}

- (void) close
{
}

#pragma mark NSInputStream methods

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len
{
    [_buffer setLength:1024];
    int read = [self readBytes:[_buffer bytes] length:1024];
    if (len) *len = read;
    return YES;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    return [self readBytes:buffer length:len];
}

- (BOOL)hasBytesAvailable
{
    return YES;
}

#pragma mark NSFileHandle methods

// NSFileHandle methods

- (NSData *)availableData
{
    return [self readData:4096];
}

- (NSData *)readDataOfLength:(NSUInteger)length
{
    return [self readData:length];
}

- (NSData *)readDataToEndOfFile
{
    return [self readData:[self remainingBytes]];
}


#pragma mark cleanup

- (void) dealloc
{
    [_buffer release];
    [super dealloc];
}

@end
