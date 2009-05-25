//
//  NWMappedFileData.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NWTempFileHandle;

@interface NWMappedFileData : NSProxy {
    NSData*               _realData;
    NSString*             _path;
    NWTempFileHandle*     _tempHandle;
    BOOL                  _deleteWhenDone;
}

@property (readonly) NSString*             path;
@property (readonly) BOOL                  deleteWhenDone;
@property (readonly) NWTempFileHandle*     tempHandle;

+ (NSData*) dataWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;
+ (NSData*) dataWithPath:(NSString*)path range:(NSRange)range deleteWhenDone:(BOOL)dod;
+ (NSData*) dataWithTempFileHandle:(NWTempFileHandle*)handle;
+ (NSData*) dataWithTempFileHandle:(NWTempFileHandle*)handle range:(NSRange)range;

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;
- (id) initWithTempFileHandle:(NWTempFileHandle*)handle;

@end
