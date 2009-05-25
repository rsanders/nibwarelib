//
//  NibwareIOBase.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//



@interface NibwareIOException : NSException {
}
@end


@interface NWTempFileHandle : NSObject {
    NSString*         _path;
    BOOL              _deleteWhenDone;
}
@property (readonly) NSString*         path;
@property (readonly) BOOL              deleteWhenDone;

+ (NWTempFileHandle*) handleWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;
+ (NWTempFileHandle*) handleWithPath:(NSString*)path;

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;

@end