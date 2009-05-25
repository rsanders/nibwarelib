//
//  NibwareDataOutputStream.h
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareOutputStream.h"

@interface NibwareDataOutputStream : NibwareBaseOutputStream <NibwareOutputStream> {
    NSMutableData             *_data;
}

@property (readonly) NSMutableData             *data;

- (id) initWithData:(NSMutableData*)data;

@end
