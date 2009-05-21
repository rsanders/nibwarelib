//
//  UIImage+Nibware.h
//  pingle
//
//  Created by robertsanders on 1/10/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Nibware) 

- (UIImage *)scaleAndRotateImage:(NSInteger)kMaxResolution;
- (UIImage *)scaleAndRotateImage:(NSInteger)kMaxResolution withSubrect:(CGRect)subRect;

@end
