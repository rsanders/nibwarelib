//
//  UIImage+Subimage.m
//  pingle
//
//  Created by robertsanders on 4/30/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "UIImage+Subimage.h"


@implementation UIImage(Subimage)



- (UIImage*)subImageInRect:(CGRect)rect
{
    CGImageRef origCG = [self CGImage];
    
    CGImageRef newCG = CGImageCreateWithImageInRect(origCG, rect);
    
    return [[[UIImage alloc] initWithCGImage:newCG] autorelease];
}


@end
