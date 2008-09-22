//
//  NibwareAlert.m
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareAlert.h"

@implementation NibwareAlert

@synthesize actionSheet;
@synthesize releaseSelf;

+ (void) alertWithMessage:(NSString *)message inView:(UIView *)view {
    NibwareAlert *alert = [NibwareAlert new];
    alert.releaseSelf = YES;
    [alert showWithMessage:message inView:view];
}

- (void) init {
    [super init];
    releaseSelf = YES;
}

- (void)showWithMessage:(NSString *)message inView:(UIView *)view {
    actionSheet = [[UIActionSheet alloc] 
                   initWithTitle:message
                   delegate:self 
                   cancelButtonTitle:nil 
                   destructiveButtonTitle:@"OK" 
                   otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:view];
}

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [sheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [sheet removeFromSuperview];
    if (releaseSelf) {
        [self release];
    }
}

- (void)dealloc {
    [actionSheet release];
    [super dealloc];
}

@end
