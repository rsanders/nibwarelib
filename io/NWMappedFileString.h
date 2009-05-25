//
//  NWMappedFileString.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NWMappedFileData.h"

#define NWMappedFileString_MaxWidth 4

@interface NWMappedFileString : NSString {
    NSData*               _mappedData;
    NSStringEncoding      _mappedEncoding;
    int                   _mappedWidth;
    char                  _transform[NWMappedFileString_MaxWidth];
}

@property (readonly) NSData*   mappedData;

+ (BOOL) isEncodingSupported:(NSStringEncoding)encoding;

+ (NWMappedFileString*) stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

+ (NWMappedFileString*) stringWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod;


- (id) initWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

- (id) initWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod;


@end
