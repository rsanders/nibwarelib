//
//  PingleUrlUtils.m
//  pingle
//
//  Created by Robert Sanders on 9/17/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareUrlUtils.h"

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

+ (NSString *) dictToQueryString:(NSDictionary *)dict {
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    NSMutableString *string = [NSMutableString stringWithString:@""];
    
    NSString *sep = @"";
    while ((key = [enumerator nextObject])) {
        NSString *escapedKey = [self urlencode:key];
        NSString *escapedValue = [self urlencode:[dict valueForKey:key]];
        
        [string appendString:[NSString stringWithFormat:@"%@%@=%@", 
                              sep, escapedKey, escapedValue]];
        
        sep = @"&";
    }
    
    return string;
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
        
        if (i == 0) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] 
                              dataUsingEncoding:encoding]];
        }
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename] 
                          dataUsingEncoding:encoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType]
                          dataUsingEncoding:encoding]];
        [body appendData:body];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] 
                          dataUsingEncoding:encoding]];
    }

	[request setHTTPBody:body];
    [body release];
}

@end
