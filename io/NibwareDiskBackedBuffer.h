//
//  NibwareDiskBackedBuffer.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareIOBase.h"
#import "NibwareInputStream.h"
#import "NibwareOutputStream.h"

@interface NibwareDiskBackedBuffer : NSObject <NibwareOutputStream> {
    id<NibwareOutputStream>         _output;
    NSUInteger                       _maxSize;
    NSUInteger                       _written;
    NSString                        *_path;
    BOOL                             _deleteWhenDone;
    
    id<NibwareInputStream>          _inputStream;
    NSData*                         _inputData;
}

@property (assign)    NSUInteger                       maxSize;
@property (readonly)  NSUInteger                       written;

@property (readonly)  id<NibwareInputStream>           inputStream;
@property (readonly)  NSData*                          inputData;

- (id) initWithMaxSize:(NSUInteger)max capacity:(NSUInteger)cap;

- (NSString*) inputString:(NSStringEncoding)encoding;

@end
