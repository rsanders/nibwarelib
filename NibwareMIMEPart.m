//
//  NibwareMIMEPart.m
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareMIMEPart.h"


@implementation NibwareMIMEPart

@synthesize body;
@synthesize name;
@synthesize fileName;
@synthesize mimeType;

+ (NibwareMIMEPart*) mimePartFromFile:(NSString*)fileName mimeType:(NSString *)mimeType
{
    return [[[NibwareMIMEPart alloc] initWithFile:fileName mimeType:mimeType] autorelease];
}


+ (NibwareMIMEPart*) mimePartFromData:(NSData*)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    return [[[NibwareMIMEPart alloc] initWithData:data fileName:fileName mimeType:mimeType] autorelease];
}

- (NibwareMIMEPart*) initWithFile:(NSString*)newfileName mimeType:(NSString *)newmimeType
{
    return [self initWithData:[NSData dataWithContentsOfMappedFile:newfileName] fileName:newfileName mimeType:newmimeType];
}


- (NSString *)translateMimeType:(NSString*)type
{
    if (type) return type;
    
    return @"application/binary";
}

- (NibwareMIMEPart*) initWithData:(NSData*)data fileName:(NSString *)newfileName mimeType:(NSString *)newmimeType
{
    self = [super init];
    
    self.body = data;
    self.fileName = newfileName;
    self.name = newfileName;
    self.mimeType = [self translateMimeType:mimeType];
    
    return self;
}

- (void) dealloc {
    [body release];
    [name release];
    [fileName release];
    [mimeType release];

    [super dealloc];
}

@end
