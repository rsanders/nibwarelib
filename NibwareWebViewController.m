//
//  NibwareWebViewController.m
//  pingle
//
//  Created by Robert Sanders on 9/23/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareWebViewController.h"
#import "Nibware.h"


@implementation NibwareWebViewController

@synthesize loadJSLib, otherJSLibs, delegate;

- (void) init {
    [super init];
    passNext = NO;
    loadJSLib = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [(UIWebView*)self.view setDelegate:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    otherJSLibs = Nil;
    
    [super dealloc];
}

#pragma mark HTML Munging

- (void)insertJavascriptByURL:(NSURL *)url {
}

- (void)insertJavascriptString:(NSString *)script {
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType 
{
    NSLog(@"wVsSLWR, req=%@", request);
    // request.URL = [NSURL URLWithString:@"http://robertsanders.name/dev/pingle/about2.html"];

    //if ([[[request URL] path] isEqualToString:@"/dev/pingle/about2.html"]) {

    if (passNext || true) {
        passNext = NO;
        return YES;
    } 

    passNext = YES;
    [webView performSelectorOnMainThread:@selector(loadRequest:)
                              withObject:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://robertsanders.name/dev/pingle/about2.html"]]
                          waitUntilDone:NO];
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"wVDSL");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"wVDFL");
    if (loadJSLib || true) {
        NSLog(@"loading JSlib");
        
        NSString *jspath = [NSString stringWithFormat:@"file://%@",
                            [[NSBundle mainBundle] pathForResource:@"rew" ofType:@"js"]];
        jspath = @"http://robertsanders.name/dev/pingle/rew.js";
        NSLog(@"jspath = %@", jspath);

        // [webView stringByEvaluatingJavaScriptFromString:@"jquery('#outbox').text('first pass');"];
        
        NSString *jsstring = [NSString stringWithFormat:
@""
"alert('no runny');"                              
"(function() {"
"  var head = document.getElementsByTagName('head')[0];"
"  var script = document.createElement('script');"
"  script.setAttribute('type', 'text/javascript');"
"  script.setAttribute('src', '%@');"
"  head.appendChild(script);"
"})();", jspath];
        
        // jsstring = @"jQuery('#outbox').text('foobar');";
        
        NSLog(@"inserting JS: %@", jsstring);
        
//        [webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsstring
//                               waitUntilDone:NO];
        [webView stringByEvaluatingJavaScriptFromString:jsstring];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"wVdFLWE: %@", error);
}

#pragma mark NibwareWebViewDelegate

@end

