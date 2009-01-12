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

@end
