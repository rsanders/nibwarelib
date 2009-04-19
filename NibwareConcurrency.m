//
//  NibwareConcurrency.m
//  pingle
//
//  Created by robertsanders on 4/18/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareConcurrency.h"

@implementation NibwareNSOperation 

- (NibwareNSOperation*) initWithObject:(id<NSObject>)object
{
    self = [super init];
    object_ = [object retain];
    return self;
}

- (NibwareNSOperation*) initWithObject:(id<NSObject>)object selector:(SEL)sel args:(NSArray *)args
{
    self = [super init];
    selector_ = sel;
    object_ = [object retain];
    args_ = [args retain];
    
    return self;
}

- (NibwareNSOperation*) initWithObject:(id<NSObject>)object selector:(SEL)sel arg:(id)arg
{
    self = [super init];
    selector_ = sel;
    object_ = [object retain];
    args_ = [[NSArray arrayWithObject:arg] retain];
    
    return self;
}


- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    return [(NSObject*)object_ methodSignatureForSelector:selector];
}


- (void)forwardInvocation:(NSInvocation*)invocation {    
    [invocation setTarget:object_];
    [invocation retainArguments];
    invocation_ = [invocation retain];
}

- (void) main
{
    if (invocation_) 
    {
        [invocation_ invoke];
    } 
    else 
    {
        [object_ performSelector:selector_ withObject:[args_ objectAtIndex:0]];
    }
}

- (void) dealloc
{
    [object_ release];
    [args_ release];
    [invocation_ release];
    [super dealloc];
}
@end


@implementation NibwareConcurrency

@end
