//
//  NibwareFileInputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareFileInputStream.h"

#import <sys/stat.h>

@implementation NibwareFileInputStream


@synthesize file = _file;

- (id) initWithFile:(NSFileHandle*)file
{
    self = [super init];
    self.file = file;
    return self;
}

#pragma mark Protocol methods

- (NSData*) readData:(NSUInteger)length
{
    return [_file readDataOfLength:length];
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

- (NSInteger) remainingBytes
{
    NSInteger res = -1;
    @try {
        unsigned long long offset = [_file offsetInFile];
        res = fmax([self size] - offset, 0);
    } @catch (NSException *e) {
    }
    return -1;
}

- (void) close
{
}

#pragma mark Cleanup

- (void) dealloc
{
    [self close];
    [_file release];
    [super dealloc];
}

@end
