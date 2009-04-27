//
//  NibwareFileManager.m
//  pingle
//
//  Created by robertsanders on 1/11/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#include <stdlib.h>

#import "NibwareFileManager.h"

static NSMutableArray *_tempFiles;

@implementation NibwareFileManager

+ (NibwareFileManager*) singleton 
{
    static NibwareFileManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[NibwareFileManager alloc] init];
        
        return sharedSingleton;
    }
    
    // shutup Xcode
    return sharedSingleton;
}

+ (void) atexit
{
    NSLog(@"removing temporary files for NibwareFileManager");
    for (NSString *name in _tempFiles)
    {
        NSLog(@"deleting app-scope temp file %@", name);
        unlink([name cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

void NibwareFileManagerAtexit()
{
    [NibwareFileManager atexit];
}

+ (id) initialize
{
    _tempFiles = [[NSMutableArray alloc] init];
    atexit(NibwareFileManagerAtexit);
    return self;
}

- (NibwareFileManager *)init
{
    return self;
}

- (NSString *) makeTempFileName:(NSString *)format
{
    static BOOL seeded = NO;

    NSString *tmpdir = NSTemporaryDirectory();

    if (! seeded) {
        sranddev();
    }

    NSString *rndstr = [[NSNumber numberWithInt:rand()] stringValue];
    return [[NSString stringWithFormat:@"%@%@",
             tmpdir,
             [NSString stringWithFormat:format, rndstr]]
            stringByStandardizingPath];
}

- (NSString *) makeTempFileName
{
    return [self makeTempFileName:@"tmp.nw.%@"];
}

            
- (void) registerApplicationScopeFile:(NSString*)fileName
{
    if (fileName) {
        [_tempFiles addObject:fileName];
    }
}

- (NSFileHandle *) createApplicationScopeTempFile
{
    NSString *fileName = [self makeTempFileName];
    [self registerApplicationScopeFile:fileName];
    if (![[NSFileManager defaultManager] createFileAtPath:fileName contents:[NSData data] attributes:nil]) {
        return nil;
    }
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file truncateFileAtOffset:0];
    return file;
}


#define ADD_MAP_ENTRY(a,b)   do { id key = (a), value = (b); \
                                  if (toFlag) { id tmp = key; key = value; value = tmp; } \
                                  [dict setObject:value forKey:key]; } while(0)

- (NSDictionary*) getRelativeMap:(BOOL) toFlag
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // ADD_MAP_ENTRY(@"%%DOCUMENTS%%", documentsDirectory);
    ADD_MAP_ENTRY(@"%%NSHOMEDIR%%", NSHomeDirectory());
    return dict;
}

- (NSString *) convertPath:(NSString *)path withDict:(NSDictionary *)dict
{
    for (NSString *fromString in dict) {
        if ([path hasPrefix:fromString]) {
            return [NSString stringWithFormat:@"%@%@",
                    [dict objectForKey:fromString],
                    [path substringFromIndex:[fromString length]]];
        }
    }
    return path;
}

- (NSString *) convertToAppRelativePath:(NSString *)path
{
    return [self convertPath:path withDict:[self getRelativeMap:YES]];
}

- (NSString *) convertFromAppRelativePath:(NSString *)path
{
    return [self convertPath:path withDict:[self getRelativeMap:NO]];
}

@end
