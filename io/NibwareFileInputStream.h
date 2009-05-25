//
//  NibwareFileInputStream.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareInputStream.h"

@interface NibwareFileInputStream : NibwareBaseInputStream <NibwareInputStream> {
    NSFileHandle*              _file;
}

@property (retain) NSFileHandle*              file;

- (id) initWithFile:(NSFileHandle*)file;

@end
