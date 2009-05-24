//
//  NibwareStringUtils.m
//  pingle
//
//  Created by Robert Sanders on 9/22/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "NibwareStringUtils.h"


@implementation NibwareStringUtils

+ (BOOL) stringContains:(NSString *)string substring:(NSString *)substring {
    NSRange range = [string rangeOfString:substring];
    return (range.length != 0);
}


+ (NSString *) friendlyDataSize:(NSInteger)length decimalPlaces:(int)places
{
    float num = length;
    NSString *units;
    if (places == -1) {
        places = 1;
    }
    
    if (length >= 1024*1024*1024) {
        num /= (1024*1024*1024);
        units = @"GB";
    } else if (length >= 1024*1024) {
        num /= (1024*1024*1024);
        units = @"MB";
    } else if (length >= 1024) {
        num /= 1024;
        units = @"KB";
    } else {
        units = @"B";
        places = 0;
    }
    
    NSString *fmtString;
    if (places > 0) {
        fmtString = [NSString stringWithFormat:@"%%.%df %%@", places];
    } else {
        fmtString = [NSString stringWithFormat:@"%%.0f %%@"];
        num = round(num);
    }
    
    return [NSString stringWithFormat:fmtString, num, units];
}


+ (NSString *) friendlyDurationInSeconds:(NSInteger)seconds
{
    NSMutableString *res = [[NSMutableString alloc] init];
    
    float num = seconds / 3600.0;
    if (num >= 1) {
        [res appendFormat:@"%dh", (int)num];
    }

    num = (num - trunc(num)) * 60;
    if (num >= 1) {
        [res appendFormat:@"%dm", (int)num];
    }

    num = (num - trunc(num)) * 60;
    if (num >= 1) {
        [res appendFormat:@"%ds", (int)num];
    }
    
    return [res autorelease];
}

#pragma mark XML escaping

+ (NSString*) escapeForXML:(NSString *)string
{
    NSMutableString *mut = [[NSMutableString alloc] initWithCapacity:string.length];

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i = 0; i < string.length; i++) {
        unichar prochar = [string characterAtIndex:i];
        NSString *replacement = nil;
        switch (prochar) {
            case '&':
                replacement = @"&amp;";
                break;
            case '<':
                replacement = @"&lt;";
                break;
            case '>':
                replacement = @"&gt;";
                break;
        }
        if (replacement) [mut appendString:replacement];
        else {
            [mut appendFormat:@"%C", prochar];
        }
        if (i % 50 == 0) [pool drain];
    }
    [pool release];

    return [mut autorelease];
}



//////////////////////////////////////

#if 0
+ (void)detectURLs:(NSString*)string color:(NSColor*)linkColor
{
	NSScanner*					scanner;
	NSRange						scanRange;
	NSString*					scanString;
	NSCharacterSet*				whitespaceSet;
	NSURL*						foundURL;
	NSDictionary*				linkAttr;
	
	// Create our scanner and supporting delimiting character set
	scanner = [NSScanner scannerWithString:[string string]];
	whitespaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	// Start Scan
	while( ![scanner isAtEnd] )
	{
		// Pull out a token delimited by whitespace or new line
		[scanner scanUpToCharactersFromSet:whitespaceSet intoString:&scanString];
		scanRange.length = [scanString length];
		scanRange.location = [scanner scanLocation] - scanRange.length;
		
		// If we find a url modify the string attributes
		if(( foundURL = findURL(scanString) ))
		{
			// Apply underline style and link color
			linkAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                        foundURL, NSLinkAttributeName,
                        [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                        linkColor, NSForegroundColorAttributeName, NULL ];
			[self addAttributes:linkAttr range:scanRange];
		}
	}
}

NSURL* findURL(NSString* string)
{
	NSRange		theRange;
	
	// Look for ://
	theRange = [string rangeOfString:@"://"];
	if( theRange.location != NSNotFound && theRange.length != 0 )
		return [NSURL URLWithString:string];
	
	// Look for www. at start
	theRange = [string rangeOfString:@"www."];
	if( theRange.location == 0 && theRange.length == 4 )
		return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", string]];
	
	// Look for ftp. at start
	theRange = [string rangeOfString:@"ftp."];
	if( theRange.location == 0 && theRange.length == 4 )
		return [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", string]];
    
	// Look for mailto: at start
	theRange = [string rangeOfString:@"mailto:"];
	if( theRange.location == 0 && theRange.length == 7 )
		return [NSURL URLWithString:string];

	return nil;
}

// \(?\bhttp://[-A-Za-z0-9+&@#/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#/%=~_()|]

#endif

@end
