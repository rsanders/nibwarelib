//
//  PingleUrlUtils.m
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareUrlUtils.h"
#import "NibwareFileManager.h"
#import "NibwareMIMEPart.h"

@implementation NibwareUrlUtils

+(NSString *) urlencode:(NSString *)string
{
    NSString *newstring = (NSString *) 
        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                (CFStringRef) string, 
                                                NULL,       // those to leave unescaped
                                                CFSTR("?=&+\" "),  // legal URL chars to escape
                                                kCFStringEncodingUTF8);
    
    return newstring;
}

+(NSString *) urldecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+(NSDictionary *) parseQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [[NSMutableDictionary new] autorelease];
    if (queryString && [queryString length] > 0) {
        NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
        NSString *pair;
        for (pair in pairs) {
            NSArray *keyval = [pair componentsSeparatedByString:@"="];
            NSString *key = [keyval objectAtIndex:0];
            NSString *val = [keyval objectAtIndex:1];
            key = [self urldecode:key];
            val = [self urldecode:val];
            [dict setValue:val forKey:key];
        }
    }
    
    return dict;
}

+ (NSData*) dictToQueryData:(NSDictionary *)dict
{
    NSString *path = [[NibwareFileManager singleton] makeTempFileName];
    [[NibwareFileManager singleton] registerApplicationScopeFile:path];
    
    NSInteger size = [self dictToQueryFile:dict path:path];
    if (size == -1)
        return nil;

    NSUInteger options = NSMappedRead;
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:options error:&error];
    if (! data || error) {
        NSLog(@"could not map file %@: %@", path, error);
    }

    return data;
}

+ (NSInteger) dictToQueryFile:(NSDictionary *)dict path:(NSString*)path {
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;

    if (![[NSFileManager defaultManager] createFileAtPath:path
                                            contents:[NSData data]
                                               attributes:nil])
    {
        NSLog(@"could not create temp file");
        return -1;
    }

    NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:path] retain];
    if (!file) {
        NSLog(@"dictToQueryData could not open file %@", path);
        return -1;
    }
    [file truncateFileAtOffset:0];
    
    NSString *sep = @"";
    while ((key = [enumerator nextObject])) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *escapedKey = [self urlencode:key];
        [file writeData:[[NSString stringWithFormat:@"%@%@=", 
                          sep, escapedKey] dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSData class]]) {
            [file writeData:(NSData *)value];
        } else if ([value isKindOfClass:[NSString class]]) {
            NSString *escapedValue = [self urlencode:(NSString *)value];
            [file writeData:[escapedValue dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [file writeData:[@"unknown" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [pool release];
        sep = @"&";
    }

    [file closeFile];
    [file release];

    NSDictionary *att = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
    NSNumber *size = [att objectForKey:NSFileSize];
    return size ? [size unsignedLongLongValue] : -1;
}

+ (NSString *) dictToQueryString:(NSDictionary *)dict {
    return [[NSString alloc] initWithData:[NibwareUrlUtils dictToQueryData:dict]
                                 encoding:NSUTF8StringEncoding];
}

+ (void)setMIMEBody:(NSMutableURLRequest *)request withParts:(NSArray *)parts {
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
     
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
    NSStringEncoding encoding = NSUTF8StringEncoding;
	NSMutableData *body = [[NSMutableData data] retain];
    
    for (int i = 0; i < [parts count]; i++) {
        NibwareMIMEPart *part = (NibwareMIMEPart *)[parts objectAtIndex:i];
        NSString *filename = part.fileName;
        NSString *name = part.name;
        NSString *mimeType = part.mimeType;
        if (mimeType == nil || [mimeType length] == 0) {
            mimeType = @"application/octet-stream";
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] 
                         dataUsingEncoding:encoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename] 
                          dataUsingEncoding:encoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType]
                          dataUsingEncoding:encoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", [[part body] length]]
                          dataUsingEncoding:encoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:encoding]];

        [body appendData:part.body];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] 
                      dataUsingEncoding:encoding]];

	[request setHTTPBody:body];
    [body release];
}

@end
