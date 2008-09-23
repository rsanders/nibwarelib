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

#define DEFAULT_FONT_SIZE  12.0

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


- (CGRect)getVisibleRectangle:(UIScrollView *) view {
    CGPoint point = [view contentOffset];
    CGRect rect;

    rect.origin = point;
    rect.size = view.bounds.size;
    
    return rect;
}

#pragma mark Event handling

- (void)logNotification:(NSNotification *)notification {
    NSString *message = [[notification userInfo] objectForKey:@"message"];
    
    // CGSize size = logBox.contentSize;
    CGRect currentRect = [self getVisibleRectangle:logBox];
    [logBox setText:[NSString stringWithFormat:@"%@%@\n", logBox.text, message]];

    // [self repositionAnimatedFrom:[self bottomRectForSize:size]];
    [self repositionAnimatedFrom:currentRect];    
}

#pragma mark Initialization

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loaded");
    logBox.editable = NO;
    logBox.text = @"";
    logBox.font = [UIFont fontWithName:@"Courier" size:10.0];
    logBox.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    logBox.maximumZoomScale = 4.0;
    logBox.minimumZoomScale = 0.5;
    logBox.delegate = self;

    zoomScale = 1.0;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(logNotification:) name:NIBWARE_NOTIFICATION_LOG object:Nil];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    savedBounds = logBox.frame;
    logBox.font = [UIFont fontWithName:@"Courier" size:DEFAULT_FONT_SIZE];

    return logBox;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"debug view zoomed to scale %f", scale);
    if (scale >= 0.9 && scale < 1.1) {
        scale = 1.0;
        NSLog(@"scale near to zero, resetting to 1");
    }
    zoomScale = scale;
    
    view.transform = CGAffineTransformIdentity;
    view.frame = savedBounds;
    float fontSize = scale * DEFAULT_FONT_SIZE;
    logBox.font = [UIFont fontWithName:@"Courier" size:fontSize];
    NSLog(@"effective font size is %f", logBox.font.pointSize);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"debug view appeared");
    
    if (! [logBox.text isEqualToString:@""]) {
        NSLog(@"already initialized, not recreating full text");
        return;
    }
    
    NSMutableString *text = [[[NSMutableString alloc] init] autorelease];
    NSString *message;
    NSArray *messages = [[[NibwareLog singleton] messages] copy];
    for (message in messages)
    {
        [text appendString:message];
        [text appendString:@"\n"];
    }
    [messages release];
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
