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

- (void) smoothScrollToBottom {
    NSRange range;
    range.location = [logBox.text length] - 1;
    range.length = 1;
    [logBox scrollRangeToVisible:range];
}

- (void) repositionAnimatedFrom:(CGRect)rect {
    logBox.bounds = rect;
    [self smoothScrollToBottom];
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
    CGRect rect = view.bounds;
    return rect;
}

#pragma mark Event handling


- (void)doLogNotification:(NSNotification *)notification {
    NSString *message = [[notification userInfo] objectForKey:@"message"];
    
    CGRect currentRect = logBox.bounds;
    [logBox setText:[NSString stringWithFormat:@"%@%@\n", logBox.text, message]];
    logBox.bounds = currentRect;
    // [self repositionAnimatedFrom:currentRect];    
    [self smoothScrollToBottom];
}

- (void)logNotification:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(doLogNotification:) withObject:notification waitUntilDone:NO];
}
    

#pragma mark Initialization

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"nibware debug view loaded");
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.superview.autoresizesSubviews = YES;

    logBox.editable = NO;
    logBox.text = @"";
    logBox.font = [UIFont fontWithName:@"Courier" size:10.0];
    logBox.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    logBox.maximumZoomScale = 4.0;
    logBox.minimumZoomScale = 0.5;
    logBox.delegate = self;
    zoomScale = 1.0;
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
    static BOOL subscribed = NO;
    
    [super viewDidAppear:animated];
    NSLog(@"debug view appeared");
    
    if (! subscribed)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(logNotification:) name:NIBWARE_NOTIFICATION_LOG object:Nil];        
        subscribed = YES;
    }

    if (! [logBox.text isEqualToString:@""]) {
        NSLog(@"already initialized, not recreating full text");
        return;
    }
    
    self.view.frame = self.view.superview.frame;
    logBox.frame = self.view.frame;
    
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
    NWLog(@"debug view asked about rotating");
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGRect bounds = self.view.bounds;
    NSLog(@"NDVC: didRotate, laying out...new bounds are %f, %f, %f, %f",
          bounds.origin.x, bounds.origin.y,
          bounds.size.width, bounds.size.height);
    bounds = [[self.view superview] bounds];
    NSLog(@"NDVC: ...superview bounds are %f, %f, %f, %f",
          bounds.origin.x, bounds.origin.y,
          bounds.size.width, bounds.size.height);
    self.view.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    // [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
    
    [logBox performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
    NSLog(@"NibwareDebugViewController: Cleared for memory warning");
}


- (void)dealloc {
    [super dealloc];
}


@end
