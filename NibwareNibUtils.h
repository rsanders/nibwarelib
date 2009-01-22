//
//  NibwareNibUtils.h
//  pingle
//
//  Created by robertsanders on 1/18/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NibwareNibUtils : NSObject {

}

+ (UITableViewCell*) loadReusableCell:(NSString*)cellid fromNib:(NSString *)nibName;
+ (UITableViewCell*) loadNewCellfromNib:(NSString *)nibName;

@end
