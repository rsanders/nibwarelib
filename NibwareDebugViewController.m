//
//  NibwareDebugViewController.m
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareDebugViewController.h"

#import "NibwareLog.h"

#undef NSLog

@implementation NibwareDebugViewController

@synthesize logBox;

- (void) repositionAnimatedFrom:(CGRect) rect {
    NSRange range;
    range.location = [logBox.text length] - 1;
    [logBox scrollRectToVisible:rect animated:NO];
    [logBox scrollRangeToVisible:range];
}

- (CGRect)bottomRectForSize:(CGSize) size {
    CGRect bounds;
    
    bounds.origin.x = 0;
    bounds.origin.y = size.height-1;
    bounds.size.height = 1;
    bounds.size.width = 1;
    return bounds;
}

- (void) repositionToBottom {
    CGSize size = logBox.contentSize;
    CGRect bounds;
    
    bounds.origin.x = 0;
    bounds.origin.y = size.height-1;
    bounds.size.height = 1;
    bounds.size.width = 1;

    [logBox scrollRectToVisible:bounds animated:NO];
}


#pragma mark Event handling

- (void)logNotification:(NSNotification *)notification {
    NSString *message = [[notification userInfo] objectForKey:@"message"];
    
    CGSize size = logBox.contentSize;
    [logBox setText:[NSString stringWithFormat:@"%@%@\n", logBox.text, message]];

    [self repositionAnimatedFrom:[self bottomRectForSize:size]];
}

#pragma mark Initialization

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loaded");
    logBox.editable = NO;
    logBox.text = @"";
    logBox.font = [UIFont fontWithName:@"Courier" size:10.0];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(logNotification:) name:NIBWARE_NOTIFICATION_LOG object:Nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NWLog(@"debug view appeared");
    
    NSMutableString *text = [[[NSMutableString alloc] init] autorelease];
    NSString *message;
    for (message in [[NibwareLog singleton] messages])
    {
        [text appendString:message];
        [text appendString:@"\n"];
    }
    [logBox setText:text];
    [self repositionToBottom];
}

#pragma mark Boilerplate view controller stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    NWLog(@"asked about rotating");
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
