//
//  NibwareFileOutputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#include <sys/stat.h>
#include <sys/unistd.h>

#import "NibwareFileOutputStream.h"
#import "NSFileHandle+MutableData.h"

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


#pragma mark NSMutableData like methods

// more methods mainly intended to mollify NSMutableData users
- (void)increaseLengthBy:(NSUInteger)extraLength
{
    [_file increaseLengthBy:extraLength];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes
{
    [_file replaceBytesInRange:range withBytes:bytes];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength
{
    [_file replaceBytesInRange:range withBytes:replacementBytes length:replacementLength];
}

- (void)resetBytesInRange:(NSRange)range
{
    [_file resetBytesInRange:range];
}

- (void)setData:(NSData *)aData
{
    [_file setData:aData];
}

- (void)setLength:(NSUInteger)length
{
    [_file setLength:length];
}

#pragma mark NSData like methods

- (NSUInteger) length
{
    return [_file length];
}

- (NSData *)subdataWithRange:(NSRange)range
{
    return [_file subdataWithRange:range];
}

- (void)getBytes:(void *)buffer
{
    [_file getBytes:buffer];
}

- (void)getBytes:(void *)buffer length:(NSUInteger)length
{
    [_file getBytes:buffer length:length];
}

- (void)getBytes:(void *)buffer range:(NSRange)range
{
    [_file getBytes:buffer range:range];
}


#pragma mark Cleanup

- (void) dealloc
{
    [self close];
    [_file release];
    [super dealloc];
}

@end
