//
//  NibwareURLShortener.h
//  pingle
//
//  Created by robertsanders on 5/4/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NibwareURLShortener : NSObject {
    NSString*            longString;
    NSString*            shortString;
}

@property (retain) NSString *longString, *shortString;

- (NibwareURLShortener*) initWithURLString:(NSString*)string;

- (NSString*) shorten;

@end
