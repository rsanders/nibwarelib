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
    self.data = data;
    return self;
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

#pragma mark Cleanup

- (void) dealloc
{
    
    [_data release];
    [super dealloc];
}

@end
