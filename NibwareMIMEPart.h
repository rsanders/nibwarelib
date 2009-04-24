//
//  NibwareMIMEPart.h
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibwareMIMEPart : NSObject {
    NSData   *body;
    NSString *name;
    NSString *fileName;
    NSString *mimeType;
}

@property (retain) NSData *body;
@property (retain) NSString *name;
@property (retain) NSString *fileName;
@property (retain) NSString *mimeType;

+ (NibwareMIMEPart*) mimePartFromFile:(NSString*)fileName mimeType:(NSString *)mimeType;
+ (NibwareMIMEPart*) mimePartFromData:(NSData*)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

- (NibwareMIMEPart*) initWithFile:(NSString*)fileName mimeType:(NSString *)mimeType;
- (NibwareMIMEPart*) initWithData:(NSData*)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
