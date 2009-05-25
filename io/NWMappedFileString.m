//
//  NWMappedFileString.m
//  pingle
//
//  Created by robertsanders on 5/24/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

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

- (id) initWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
    if (self = [super init])
    {
        _mappedData = [data retain];
        _mappedEncoding = encoding;
        switch (encoding) {
//            case NSUTF32BigEndianStringEncoding:
//            case NSUTF32LittleEndianStringEncoding:
//                _mappedWidth = 4;
//                break;
//            case NSUTF16BigEndianStringEncoding:
//            case NSUTF16LittleEndianStringEncoding:
//                _mappedWidth = 2;
//                break;
            case NSASCIIStringEncoding:
            case NSISOLatin1StringEncoding:
            case NSISOLatin2StringEncoding:
                _mappedWidth = 1;
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


// XXX: not even close
- (unichar)characterAtIndex:(NSUInteger)index
{
    char bytes[4];
    [_mappedData getBytes:bytes range:NSMakeRange(_mappedWidth*index, _mappedWidth)];
    
    return bytes[0];
}

//- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange
//{
//}

#pragma mark cleanup

- (void) dealloc
{
    [_mappedData release];
    [super dealloc];
}

@end
