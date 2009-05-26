//
//  NibwareDataInputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareDataInputStream.h"


@implementation NibwareDataInputStream

@synthesize data = _data;

- (id) initWithData:(NSMutableData*)data
{
    self = [super init];
    self.data = data;
    pointer = 0;
    return self;
}

#pragma mark Protocol methods

- (NSData*) readData:(NSUInteger)length
{
    if ([self remainingBytes] == 0) {
        [NibwareInputStreamException raise:@"InputStreamEOF" format:@"No more data to read"];
    }

    length = fmin(length, [self remainingBytes]);

    NSData *data = [_data subdataWithRange:NSMakeRange(pointer, length)];
    pointer += [data length];
    return data;
}

- (NSInteger) size
{
    return [_data length];
}

- (NSInteger) remainingBytes
{
    return fmax([_data length]-pointer, 0);
}

#pragma mark NSInputStream

- (BOOL)hasBytesAvailable
{
    return [self remainingBytes] > 0;
}

#pragma mark NSFileHandle


- (unsigned long long)seekToEndOfFile
{
    pointer = [_data length];
    return pointer;
}

- (void)seekToFileOffset:(unsigned long long)offset
{
    if (offset > [_data length]) {
        [NibwareIOException raise:@"SeekError" format:@"Offset %d is past end of data (%d)", offset, _data.length];
    }
    pointer = offset;
}

#pragma mark Cleanup

- (void) dealloc
{
    
    [_data release];
    [super dealloc];
}

@end
