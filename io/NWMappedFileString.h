//
//  NWMappedFileString.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NWMappedFileData.h"

@interface NWMappedFileString : NSString {
    NWMappedFileData*     _mappedData;
}

@property (readonly) NWMappedFileData*   mappedData;

+ (NWMappedFileString*) stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

+ (NWMappedFileString*) stringWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod;


- (id) initWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

- (id) initWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod;


@end
