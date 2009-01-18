//
//  NibwareNibUtils.m
//  pingle
//
//  Created by robertsanders on 1/18/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareNibUtils.h"


@implementation NibwareNibUtils


+ (UITableViewCell*) createNewHistoryCell:(NSString*)cellid fromNib:(NSString *)nibName 
{ 
    NSArray* nibContents = [[NSBundle mainBundle] 
                            loadNibNamed:nibName owner:self options:nil]; 
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
    UITableViewCell* newcell = nil; 
    NSObject* nibItem = nil; 
    while ( (nibItem = [nibEnumerator nextObject]) != nil) { 
        if ( [nibItem isKindOfClass: [UITableViewCell class]]) { 
            newcell = (UITableViewCell*) nibItem; 
            if ([newcell.reuseIdentifier isEqualToString: cellid]) 
                break; // we have a winner 
            else 
                newcell = nil; 
        } 
    } 
    return newcell; 
} 

@end
