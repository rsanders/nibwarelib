//
//  NibwareStringUtils.m
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareStringUtils.h"


@implementation NibwareStringUtils

+ (BOOL) stringContains:(NSString *)string substring:(NSString *)substring {
    NSRange range = [string rangeOfString:substring];
    return (range.length != 0);
}

@end
