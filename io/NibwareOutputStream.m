//
//  NibwareOutputStream.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareOutputStream.h"

@implementation NibwareOutputStreamException
@end

@implementation NibwareBaseOutputStream

- (void) appendData:(NSData*)data
{
    [NibwareOutputStreamException raise:@"Unimplemented" format:@"Not implemented"];
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

- (NSInteger) size
{
    return -1;
}

- (void) close
{
}

@end
