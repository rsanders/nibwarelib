//
//  PingleUrlUtils.h
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//


@interface NibwareUrlUtils : NSObject {

}


+ (NSString *) urlencode:(NSString *)string;

+ (NSString *) urldecode:(NSString *)string;

+ (NSDictionary *) parseQueryString:(NSString *)queryString;
+ (NSString *) dictToQueryString:(NSDictionary *)dict;

+ (void)setMIMEBody:(NSMutableURLRequest *)request withParts:(NSArray *)parts;

// + (NSString *)createMIMEBody:(NSMutableURLRequest *)request bodies:(NSArray *)bodies
//                       names:(NSString *)names types:(NSString *)types;


@end

