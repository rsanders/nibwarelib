//
//  NibwareDataInputStream.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareInputStream.h"

@interface NibwareDataInputStream : NibwareBaseInputStream <NibwareInputStream> {
    NSMutableData             *_data;
    NSUInteger                pointer;
}

@property (retain) NSMutableData             *data;

- (id) initWithData:(NSMutableData*)data;

@end
