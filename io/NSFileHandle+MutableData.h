//
//  NSFile+MutableData.h
//  pingle
//
//  Created by robertsanders on 5/25/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileHandle (MutableData)
- (void) appendData:(NSData*)data;
- (void) appendBytes:(const void*)bytes length:(NSUInteger)length;
- (void) appendString:(NSString*)string encoding:(NSStringEncoding)encoding;
- (void) appendObject:(id<NSCoding>)object;

// more methods mainly intended to mollify NSMutableData users
- (void)increaseLengthBy:(NSUInteger)extraLength;
- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes;
- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength;
- (void)resetBytesInRange:(NSRange)range;
- (void)setData:(NSData *)aData;
- (void)setLength:(NSUInteger)length;

// plain old NSData like methods
- (NSUInteger) size;
- (NSUInteger) length;
- (NSData *)subdataWithRange:(NSRange)range;
- (void)getBytes:(void *)buffer;
- (void)getBytes:(void *)buffer length:(NSUInteger)length;
- (void)getBytes:(void *)buffer range:(NSRange)range;


@end
