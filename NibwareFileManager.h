//
//  NibwareFileManager.h
//  pingle
//
//  Created by robertsanders on 1/11/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NibwareFileManager : NSObject {
}

+ (NibwareFileManager*) singleton;
- (NSString *) makeTempFileName;
- (void) registerApplicationScopeFile:(NSString*)fileName;
- (NSFileHandle *) createApplicationScopeTempFile;


@end
