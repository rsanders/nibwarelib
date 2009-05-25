//
//  NibwareDataOutputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareDataOutputStream.h"


@implementation NibwareDataOutputStream

@synthesize data = _data;

- (id) initWithData:(NSMutableData*)data
{
    self = [super init];
    _data = [data retain];
    return self;
}

- (id) init
{
    return [self initWithData:[NSMutableData data]];
}

#pragma mark Protocol methods

- (void) appendData:(NSData*)data
{
    [_data appendData:data];
}

- (NSInteger) size
{
    return [_data length];
}

#pragma mark NSMutableData-like methods

- (void)increaseLengthBy:(NSUInteger)extraLength {
    [_data increaseLengthBy:extraLength];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes {
    [_data replaceBytesInRange:range withBytes:bytes];
}

- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength {
    [_data replaceBytesInRange:range withBytes:replacementBytes length:replacementLength];
}

- (void)resetBytesInRange:(NSRange)range {
    [_data resetBytesInRange:range];
}

- (void)setData:(NSData *)aData {
    [_data setData:aData];
}

- (void)setLength:(NSUInteger)length {
    [_data setLength:length];
}

#pragma mark NSData like methods

- (NSUInteger) length
{
    return [_data length];
}

- (NSData *)subdataWithRange:(NSRange)range
{
    return [_data subdataWithRange:range];
}

- (void)getBytes:(void *)buffer
{
    [_data getBytes:buffer];
}

- (void)getBytes:(void *)buffer length:(NSUInteger)length
{
    [_data getBytes:buffer length:length];
}

- (void)getBytes:(void *)buffer range:(NSRange)range
{
    [_data getBytes:buffer range:range];
}


#pragma mark Cleanup

- (void) dealloc
{
    
    [_data release];
    [super dealloc];
}

@end
