//
//  NibwareOutputStream.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareIOBase.h"

@interface NibwareOutputStreamException : NibwareIOException {
}
@end

@protocol NibwareOutputStream <NSObject>

- (void) appendData:(NSData*)data;
- (void) appendBytes:(const void*)bytes length:(NSUInteger)length;
- (void) appendString:(NSString*)string encoding:(NSStringEncoding)encoding;
- (void) appendObject:(id<NSCoding>)object;

// may return -1 if unknown or unknowable
- (NSInteger) size;
- (void) close;

// more methods mainly intended to mollify NSMutableData users
- (void)increaseLengthBy:(NSUInteger)extraLength;
- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes;
- (void)replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength;
- (void)resetBytesInRange:(NSRange)range;
- (void)setData:(NSData *)aData;
- (void)setLength:(NSUInteger)length;

@end

@interface NibwareBaseOutputStream : NSObject {
}

- (void) appendBytes:(const void*)bytes length:(NSUInteger)length;
- (void) appendString:(NSString*)string encoding:(NSStringEncoding)encoding;
- (void) appendObject:(id<NSCoding>)object;

// may return -1 if unknown or unknowable
- (NSInteger) size;

- (void) close;

@end