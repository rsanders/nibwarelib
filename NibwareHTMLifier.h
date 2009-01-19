//
//  NibwareHTMLifier.h
//  pingle
//
//  Created by robertsanders on 1/19/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NibwareHTMLifierDelegate <NSObject>
- (NSString *) handleURL:(NSString *)url;
- (NSString *) handleEmailAddress:(NSString *)address;
@end

@interface NibwareHTMLifier : NSObject {
    id<NibwareHTMLifierDelegate>      delegate;
    NSString*                         urlRegex;
    NSString*                         source;
    NSMutableString*                  destination;
}

@property (retain) id<NibwareHTMLifierDelegate>             delegate;
@property (retain) NSString                   *urlRegex;
@property (retain) NSString                   *source;
@property (retain) NSMutableString            *destination;

+ (NSString *) linkifyString:(NSString *)source;

- (NibwareHTMLifier*) initWithDelegate:(id<NibwareHTMLifierDelegate>)delegate;

- (NSString *) htmlify:(NSString *)string;
@end
