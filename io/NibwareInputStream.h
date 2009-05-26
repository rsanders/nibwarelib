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

// NSInputStream methods

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;
- (BOOL)hasBytesAvailable;

// NSFileHandle methods

- (NSData *)availableData;
- (NSData *)readDataOfLength:(NSUInteger)length;
- (NSData *)readDataToEndOfFile;
- (unsigned long long)seekToEndOfFile;
- (void)seekToFileOffset:(unsigned long long)offset;

@end


@interface NibwareBaseInputStream : NSObject {
    NSMutableData*          _buffer;
}

- (NSUInteger) readBytes:(const void*)bytes length:(NSUInteger)length;
- (NSString*) readString:(NSString*)string length:(NSInteger)length encoding:(NSStringEncoding)encoding;
- (id<NSCoding>) readObject;

// may return -1 if unknown or unknowable
- (NSInteger) size;

- (NSInteger) remainingBytes;

- (void) close;

// NSInputStream methods

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;
- (BOOL)hasBytesAvailable;

// NSFilehandle methods

- (NSData *)availableData;
- (NSData *)readDataOfLength:(NSUInteger)length;
- (NSData *)readDataToEndOfFile;


@end
