//
//  NibwarePrefs.h
//  pingle
//
//  Created by Robert Sanders on 9/23/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NibwarePrefs : NSObject {

}


@end

@interface NSUserDefaults (Nibware)   

- (void) setFromDictionary:(NSDictionary *)dict;
- (void) setValueByParsedString:(NSString *)value forKey:(NSString *)key;
- (void) copyFromDictionary:(NSDictionary*)dict overwrite:(BOOL)overwrite;

@end
