//
//  NWSubrangeReferenceData.h
//  pingle
//
//  Created by robertsanders on 5/25/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NibwareIOBase.h"

@interface NWSubrangeReferenceData : NSProxy <NSCopying, NSMutableCopying> {
    NSData*             _refData;
    NSRange             _range;
}

@property (readonly) NSData*             refData;
@property (readonly) NSRange             range;

+ (NSData*) dataWithData:(NSData*)data range:(NSRange)range;
+ (NSData*) dataWithData:(NSData*)data;

- (id) initWithData:(NSData*)data range:(NSRange)range;
- (id) initWithData:(NSData*)data;


@end

@interface NSData (NonCopyingSubrange)

- (NSData*) subDataNoCopy:(NSRange)range;

@end
