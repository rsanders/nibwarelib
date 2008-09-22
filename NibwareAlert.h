//
//  NibwareAlert.h
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NibwareAlert : NSObject <UIActionSheetDelegate> {
    UIActionSheet *actionSheet;
    BOOL releaseSelf;
}

@property (retain, readonly) UIActionSheet *actionSheet;
@property (assign) BOOL releaseSelf;

- (void) showWithMessage:(NSString *)message inView:(UIView *)view;

+ (void) alertWithMessage:(NSString *)message inView:(UIView *)view;


@end
