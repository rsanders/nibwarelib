//
//  NSFile+MutableData.m
//  pingle
//
//  Created by robertsanders on 5/25/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NSFileHandle+MutableData.h"
#import "NibwareIOBase.h"
#import "NibwareFileManager.h"
#import "NibwareOutputStream.h"
#import "NibwareDiskBackedBuffer.h"

#include <string.h>
#include <unistd.h>

@implementation NSFileHandle (MutableData)

- (void) appendData:(NSData*)data
{
    [self seekToEndOfFile];
    [self writeData:data];
}

- (void) appendBytes:(const void*)bytes length:(NSUInteger)length
{
    [self appendData:[NSData dataWithBytes:bytes length:length]];
}

- (void) appendString:(NSString*)string encoding:(NSStringEncoding)encoding
{
    [self appendData:[string dataUsingEncoding:encoding]];
}

- (void) appendObject:(id<NSCoding>)object
{
    [self appendData:[NSKeyedArchiver archivedDataWithRootObject:object]];
}


- (void *)mutableBytes
{
    [NSException raise:@"Unimplemented" format:@"mutableBytes is not implemented for NSFileHandle+MutableData"];
    return NULL;
}

- (NSInteger) copyRange:(NSRange)range toOutputStream:(id<NibwareOutputStream>)output
{
    [self seekToFileOffset:range.location];
    
    NSUInteger resetLength = range.length;
    NSUInteger blockLength = fmin(resetLength, 4096);

    NSInteger copied = 0;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while (resetLength >= blockLength) {
        NSData *data = [self readDataOfLength:blockLength];
        [output appendData:data];
        copied += data.length;
        // EOF
        if (data.length < blockLength) {
            break;
        }
        resetLength -= blockLength;
        if (resetLength < blockLength) {
            blockLength = resetLength;
        }
        [pool drain];
    }
    [pool release];
    return copied;
}

// more methods mainly intended to mollify NSMutableData users
- (void)setLength:(NSUInteger)newLength {
    [self truncateFileAtOffset:newLength];
}

- (void)increaseLengthBy:(NSUInteger)extraLength {
    [self setLength:[self size] + extraLength];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes {
    unsigned long long cur = [self offsetInFile];
    [self seekToFileOffset:range.location];
    [self writeData:[NSData dataWithBytesNoCopy:(void*)bytes length:range.length]];
    [self seekToFileOffset:cur];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength {
    if (range.length == replacementLength) {
        [self replaceBytesInRange:range withBytes:replacementBytes];
        return;
    }
    unsigned long long cur = [self offsetInFile];
    NibwareDiskBackedBuffer *buf = [[NibwareDiskBackedBuffer alloc] initWithMaxSize:32768 capacity:4096];

    NSInteger mySize = [self size];
    NSInteger remainderStart = range.location + range.length;
    [self copyRange:NSMakeRange(remainderStart, mySize-remainderStart) toOutputStream:buf];
    
    [self setLength:range.location];
    [self appendBytes:replacementBytes length:replacementLength];
    [self appendData:[buf inputData]];
    [buf release];
    
    // don't try to go past new EOF
    [self seekToFileOffset:fmin(cur, mySize - range.length + replacementLength)];
}

- (void)resetBytesInRange:(NSRange)range {
    unsigned long long cur = [self offsetInFile];
    [self seekToFileOffset:range.location];

    NSUInteger resetLength = range.length;
    NSUInteger blockLength = fmin(resetLength, 4096);
    unsigned char *zeroes = malloc(blockLength);
    memset(zeroes, 0, blockLength);
    NSData *data = [[NSData alloc] initWithBytesNoCopy:zeroes length:blockLength freeWhenDone:YES];

    while (resetLength >= blockLength) {
        [self writeData:data];
        resetLength -= blockLength;
    }

    if (resetLength) {
        [self writeData:[data subdataWithRange:NSMakeRange(0, resetLength)]];
    }
    [data release];
    
    [self seekToFileOffset:cur];
}

- (void)setData:(NSData *)aData {
    [self truncateFileAtOffset:0];
    [self appendData:aData];
}

#pragma mark Plain NSData methods

- (NSUInteger) size
{
    unsigned long long cur = [self offsetInFile];
    NSInteger res = [self seekToEndOfFile];
    [self seekToFileOffset:cur];
    return res;
}

- (NSUInteger) length
{
    return [self size];
}

- (NSData *)subdataWithRange:(NSRange)range
{
    NibwareDiskBackedBuffer *buf = [[NibwareDiskBackedBuffer alloc] initWithMaxSize:16384 capacity:fmin(256, range.length)];
    [self copyRange:range toOutputStream:buf];
    NSData *data = [buf inputData];
    [buf release];
    return data;
}

- (void)getBytes:(void *)buffer
{
    [self getBytes:buffer range:NSMakeRange(0, [self length])];
}

- (void)getBytes:(void *)buffer length:(NSUInteger)length
{
    [self getBytes:buffer range:NSMakeRange(0, length)];
}

- (void)getBytes:(void *)buffer range:(NSRange)range
{
    [self synchronizeFile];
    pread([self fileDescriptor], buffer, range.length, range.location);
}

- (const void *)bytes
{
    [NibwareIOException raise:@"Unimplemented" format:@"%@ not implemented", NSStringFromSelector(_cmd)];
    return NULL;
}

@end
