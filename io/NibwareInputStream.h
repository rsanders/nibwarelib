//
//  NibwareInputStream.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareIOBase.h"

@interface NibwareInputStreamException : NibwareIOException {
}
@end

@protocol NibwareInputStream <NSObject>

- (NSData*) readData:(NSUInteger)length;
- (NSUInteger) readBytes:(const void*)bytes length:(NSUInteger)length;
- (NSString*) readString:(NSString*)string length:(NSInteger)length encoding:(NSStringEncoding)encoding;
- (id<NSCoding>) readObject;

// may return -1 if unknown or unknowable
- (NSInteger) size;

- (NSInteger) remainingBytes;

- (void) close;

@end


@interface NibwareBaseInputStream : NSObject {
}

- (NSUInteger) readBytes:(const void*)bytes length:(NSUInteger)length;
- (NSString*) readString:(NSString*)string length:(NSInteger)length encoding:(NSStringEncoding)encoding;
- (id<NSCoding>) readObject;

// may return -1 if unknown or unknowable
- (NSInteger) size;

- (NSInteger) remainingBytes;

- (void) close;

@end
