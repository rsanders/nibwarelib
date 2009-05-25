//
//  NibwareFileOutputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareFileOutputStream.h"
#include <sys/stat.h>
#include <sys/unistd.h>

@implementation NibwareFileOutputStream

@synthesize file = _file;

- (id) initWithFile:(NSFileHandle*)file
{
    self = [super init];
    self.file = file;
    return self;
}

#pragma mark Protocol methods

- (void) appendData:(NSData*)data
{
    [_file writeData:data];
}

- (NSInteger) size
{
    struct stat statbuf;
    
    [_file synchronizeFile];
    int fd = [_file fileDescriptor];
    if (fd == -1) {
        return -1;
    }
    if (fstat(fd, &statbuf) == -1) {
        return -1;
    }
    
    return statbuf.st_size;
}

- (void) close
{
    [_file synchronizeFile];
}

#pragma mark NSMutableData-like methods

- (void)setLength:(NSUInteger)newLength {
    [_file truncateFileAtOffset:newLength];
}

- (void)increaseLengthBy:(NSUInteger)extraLength {
//    NSUInteger blockLength = fmax(extraLength, 4096);
//    unsigned char *zeroes = malloc(blockLength);
//    NSData *data = [NSData dataWithBytesNoCopy:zeroes length:blockLength];
//
//    while (extraLength >= blockLength) {
//        [_file writeData:zeroData];
//        extraLength -= blockLength;
//    }
//
//    if (extraLength) {
//        [_file writeData:[NSData dataWithBytesNoCopy:zeroes length:extraLength]];
//    }
    
    [self setLength:[self size] + extraLength];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes {
    // [_data replaceBytesInRange:range withBytes:bytes];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength {
    // [_data replaceBytesInRange:range withBytes:replacementBytes length:replacementLength];
}

- (void)resetBytesInRange:(NSRange)range {
    // [_data resetBytesInRange:range];
}

- (void)setData:(NSData *)aData {
    [_file truncateFileAtOffset:0];
    [self appendData:aData];
}



#pragma mark Cleanup

- (void) dealloc
{
    [self close];
    [_file release];
    [super dealloc];
}

@end
