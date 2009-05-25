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
#import "NibwareIO.h"

@implementation NibwareUrlUtils

+(NSString *) urlencode:(NSString *)string
{
    NSString *newstring = (NSString *) 
        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                (CFStringRef) string, 
                                                NULL,       // those to leave unescaped
                                                CFSTR(":/?=&+\" "),  // legal URL chars to escape
                                                kCFStringEncodingUTF8);
    
    return [newstring autorelease];
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
    NibwareDiskBackedBuffer *buf = [[NibwareDiskBackedBuffer alloc] initWithMaxSize:16384 capacity:256];
    
    [self dictToQuery:dict outputStream:buf];
    
    NSData *ret = [buf inputData];
    [buf release];

    return ret;
}

+ (NSInteger) dictToQueryFile:(NSDictionary *)dict path:(NSString*)path {
    if (![[NSFileManager defaultManager] createFileAtPath:path
                                            contents:[NSData data]
                                               attributes:nil])
    {
        NSLog(@"could not create file at %@", path);
        return -1;
    }

    NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:path] retain];
    if (!file) {
        NSLog(@"dictToQueryData could not open file %@", path);
        return -1;
    }
    [file truncateFileAtOffset:0];

    NibwareFileOutputStream *output = [[NibwareFileOutputStream alloc] initWithFile:file];

    NSInteger size = [self dictToQuery:dict outputStream:output];

    [output close];
    [output release];
    [file closeFile];
    [file release];

    return size;
}

+ (NSInteger) dictToQuery:(NSDictionary *)dict outputStream:(id<NibwareOutputStream>)output {
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
       
    NSString *sep = @"";
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while ((key = [enumerator nextObject])) {
        NSString *escapedKey = [self urlencode:key];
        [output appendData:[[NSString stringWithFormat:@"%@%@=", 
                             sep, escapedKey] dataUsingEncoding:NSUTF8StringEncoding]];

        id<NSObject> value = [dict valueForKey:key];
        
        // first boil some common types down to their string equivalent
        // arrays and sets can only contain strings or other object that responds to description
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber*)value stringValue];
        } else if ([value isKindOfClass:[NSURL class]]) {
            value = [(NSURL*)value absoluteString];
        } else if ([value isKindOfClass:[NSArray class]]) {
            value = [self urlencode:[(NSArray*)value componentsJoinedByString:@","]];
        } else if ([value isKindOfClass:[NSSet class]]) {
            value = [self urlencode:[[(NSSet*)value allObjects] componentsJoinedByString:@","]];
        } 
        
        // now spit 'em out
        if ([value isKindOfClass:[NSString class]]) {
            NSString *escapedValue = [self urlencode:(NSString *)value];
            [output appendData:[escapedValue dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([value isKindOfClass:[NSData class]]) {
            [output appendData:(NSData *)value];
        } else if ([value respondsToSelector:@selector(description)]) {
            NSString *escapedValue = [self urlencode:[value description]];
            [output appendData:[escapedValue dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [output appendData:[@"unknownValueType" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [pool drain];
        sep = @"&";
    }
    [pool release];
    
    return [output size];
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
	// NSMutableData *body = [[NSMutableData data] retain];
    NibwareDiskBackedBuffer *buf = [[NibwareDiskBackedBuffer alloc] initWithMaxSize:16384 capacity:256];
    
    for (int i = 0; i < [parts count]; i++) {
        NibwareMIMEPart *part = (NibwareMIMEPart *)[parts objectAtIndex:i];
        NSString *filename = part.fileName;
        NSString *name = part.name;
        NSString *mimeType = part.mimeType;
        if (mimeType == nil || [mimeType length] == 0) {
            mimeType = @"application/octet-stream";
        }
        
        [buf appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] 
                         dataUsingEncoding:encoding]];
        [buf appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename] 
                          dataUsingEncoding:encoding]];
        [buf appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType]
                          dataUsingEncoding:encoding]];
        [buf appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", [[part body] length]]
                          dataUsingEncoding:encoding]];
        [buf appendData:[@"\r\n" dataUsingEncoding:encoding]];

        [buf appendData:part.body];
    }
    [buf appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] 
                      dataUsingEncoding:encoding]];

	[request setHTTPBody:[buf inputData]];
    [buf release];
}

@end
