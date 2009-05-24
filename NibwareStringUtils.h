//
//  NibwareStringUtils.h
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NibwareStringUtils : NSObject {

}

+ (BOOL) stringContains:(NSString *)string substring:(NSString *)substring;

+ (NSString *) friendlyDataSize:(NSInteger)length decimalPlaces:(int)places;
+ (NSString *) friendlyDurationInSeconds:(NSInteger)seconds;

+ (NSString*) escapeForXML:(NSString *)string;


@end
