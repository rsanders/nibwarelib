//
//  NibwareDebugViewController.h
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NibwareDebugViewController : UIViewController {
    IBOutlet UITextView   *logBox;
}

@property (retain) UITextView *logBox;

@end
