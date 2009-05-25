//
//  NWMappedFileString.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//
// see http://kevin.sb.org/2008/11/10/webkit-and-handling-of-surrogate-pairs-in-html-entities/

#import "NWMappedFileString.h"
#import "NibwareIOBase.h"

@implementation NWMappedFileString

@synthesize mappedData = _mappedData;

+ (NWMappedFileString*) stringWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod
{
    return [[[NWMappedFileString alloc] initWithPath:path encoding:encoding deleteWhenDone:dod] autorelease];

}

+ (NWMappedFileString*) stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
    return [[[NWMappedFileString alloc] initWithData:data encoding:encoding] autorelease];
}

// only handling 1 byte encodings natively for now
+ (BOOL) isEncodingSupported:(NSStringEncoding)encoding
{
    switch (encoding) {
        case NSUTF16BigEndianStringEncoding:
        case NSUTF16LittleEndianStringEncoding:
        case NSUTF32BigEndianStringEncoding:
        case NSUTF32LittleEndianStringEncoding:
        case NSASCIIStringEncoding:
        case NSISOLatin1StringEncoding:
        case NSISOLatin2StringEncoding:
            return YES;
        default:
            return NO;
    }
    
}

/*
 * Either we can't or don't think it's worthwhile encoding this, so just
 * bunt
 */
- (id) replaceWithNormalString:(NSData*)data encoding:(NSStringEncoding)encoding
{
    NSLog(@"WARNING: using a normal string rather than a mapped string for data of length %d", data.length);
    id newstring = [[NSString alloc] initWithData:data encoding:encoding];
    [self autorelease];
    return newstring;
}

- (id) initWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
    if (! [[self class] isEncodingSupported:encoding] || [data length] < 32768) {
        return [self replaceWithNormalString:data encoding:encoding];
    }
    
    if (self = [super init])
    {
        _mappedData = [data retain];
        _mappedEncoding = encoding;
        switch (encoding) {
            case NSUTF16BigEndianStringEncoding:
                _mappedWidth = 2;
                _transform[0] = 0; _transform[1] = 1;
                break;
            case NSUTF16LittleEndianStringEncoding:
                _transform[0] = 1; _transform[1] = 0;
                _mappedWidth = 2;
                break;
            case NSUTF32BigEndianStringEncoding:
                _mappedWidth = 4;
                // ignore high 16 bits
                _transform[0] = 2; _transform[1] = 3;
                _transform[2] = -1; _transform[3] = -1;
                break;
            case NSUTF32LittleEndianStringEncoding:
                _transform[0] = 1; _transform[1] = 0;
                // ignore high 16 bits
                _transform[2] = -1; _transform[3] = -1;
                _mappedWidth = 4;
                break;
            case NSASCIIStringEncoding:
            case NSISOLatin1StringEncoding:
            case NSISOLatin2StringEncoding:
                _mappedWidth = 1;
                _transform[0] = 0;
                break;
            default:
                [NibwareIOException raise:@"UnsupportedStringEncoding" format:@"Unsupported encoding: %d", encoding];
        }
    }
    return self;
}

- (id) initWithPath:(NSString*)path encoding:(NSStringEncoding)encoding deleteWhenDone:(BOOL)dod
{
    return [self initWithData:(NSData*)[NWMappedFileData dataWithPath:path deleteWhenDone:dod] encoding:encoding];
}

#pragma mark String subclassing magic

- (NSInteger) length
{
    return [_mappedData length] / _mappedWidth;
}


- (unichar)characterAtIndex:(NSUInteger)index
{
    NSAssert(_mappedWidth <= NWMappedFileString_MaxWidth, @"Mapping too wide");

    char bytes[NWMappedFileString_MaxWidth];
    [_mappedData getBytes:bytes range:NSMakeRange(_mappedWidth*index, _mappedWidth)];
    
    unichar reschar = 0;

    for (int i = 0; i < _mappedWidth; i++) {
        if (_transform[i] == -1) continue;
        reschar = reschar << 8 | bytes[_transform[i]];
    }

    return reschar;
}

- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange
{
    NSAssert(_mappedWidth <= NWMappedFileString_MaxWidth, @"Mapping too wide");
    
    char *bytes = (char *)[_mappedData bytes] + (_mappedWidth * aRange.location);
    
    for (int count = 0; count < aRange.length; count++) {
        unichar reschar = 0;
        for (int i = 0; i < _mappedWidth; i++) {
            if (_transform[i] == -1) continue;
            reschar = reschar << 8 | bytes[_transform[i]];
        }
        *buffer = reschar;
        buffer += 1;
        bytes += _mappedWidth;
    }
}

#pragma mark cleanup

- (void) dealloc
{
    [_mappedData release];
    [super dealloc];
}

@end
