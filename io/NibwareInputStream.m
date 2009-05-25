//
//  NibwareInputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareInputStream.h"

@implementation NibwareInputStreamException
@end

@implementation NibwareBaseInputStream

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

@end
