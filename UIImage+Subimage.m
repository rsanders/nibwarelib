//
//  UIImage+Subimage.m
//  pingle
//
//  Created by robertsanders on 4/30/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "UIImage+Subimage.h"

@implementation NibwareUIImage

@synthesize forcedOrientation, hasForcedOrientation;

- (id) initWithCGImage:(CGImageRef)imageRef orientation:(UIImageOrientation)orientation
{
    self = [super initWithCGImage:imageRef];
    self.forcedOrientation = orientation;
    return self;
}

- (UIImageOrientation) imageOrientation 
{
    TRACEFUNC();
    if (hasForcedOrientation) {
        return forcedOrientation;
    } else {
        return [super imageOrientation];
    }
}

- (void) setForcedOrientation:(UIImageOrientation)orientation 
{
    hasForcedOrientation = YES;
    forcedOrientation = orientation;
}

- (CGSize) size
{
    if (! hasForcedOrientation) {
        return [super size];
    }
    
    CGSize size = [super size];
    switch (forcedOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            return CGSizeMake(size.height, size.width);
        default:
            return size;
    }
}

@end

@implementation UIImage(Subimage)

- (CGAffineTransform) transformForOrientation
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);

    CGSize imageSize = CGSizeMake(width, height);
    CGFloat boundHeight;
    
    switch(self.imageOrientation) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    return transform;
}


- (UIImage*)subImageInRect:(CGRect)rect
{
    CGImageRef origCG = [self CGImage];

    NSLog(@"UIImage(Subimage): orientation is %d, CG size = %d x %d", 
          [self imageOrientation], (int)CGImageGetWidth(origCG), (int)CGImageGetHeight(origCG));

    NSLog(@"         orig rect is %.0f,%.0f %.0f x %.0f",
          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGAffineTransform xform = [self transformForOrientation];
    xform = CGAffineTransformInvert(xform);
    rect = CGRectApplyAffineTransform(rect, xform);
    
    NSLog(@"         new rect is %.0f,%.0f %.0f x %.0f",
          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGImageRef newCG = CGImageCreateWithImageInRect(origCG, rect);    

    NSLog(@"         resulting CG size = %d x %d", 
          (int)CGImageGetWidth(origCG), (int)CGImageGetHeight(origCG));

    return [[[NibwareUIImage alloc] initWithCGImage:newCG orientation:[self imageOrientation]] autorelease];
}

- (UIImage*) imageWithoutOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }

    CGImageRef origCG = [self CGImage];
    
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(origCG), CGImageGetHeight(origCG));

    NSLog(@"UIImage(Subimage): orientation is %d, CG size = %d x %d", 
          [self imageOrientation], (int)CGImageGetWidth(origCG), (int)CGImageGetHeight(origCG));
    
    NSLog(@"         new rect is %.0f,%.0f %.0f x %.0f",
          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGImageRef newCG = CGImageCreateWithImageInRect(origCG, rect);    
    
    NSLog(@"         resulting CG size = %d x %d", 
          (int)CGImageGetWidth(origCG), (int)CGImageGetHeight(origCG));
    
    return [[[UIImage alloc] initWithCGImage:newCG] autorelease];
}

@end
