//
//  NWMappedFileData.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NWMappedFileData : NSData {
    NSString*             _path;
    BOOL                  _deleteWhenDone;
}

@property (retain) NSString*             path;
@property (assign) BOOL                  deleteWhenDone;

+ (NWMappedFileData*) dataWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;

- (id) initWithPath:(NSString*)path deleteWhenDone:(BOOL)dod;


@end
