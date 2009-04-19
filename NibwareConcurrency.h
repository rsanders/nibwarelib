//
//  NibwareConcurrency.h
//  pingle
//
//  Created by robertsanders on 4/18/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NibwareNSOperation : NSOperation {
    SEL          selector_;
    NSArray*     args_;
    id<NSObject> object_;
    NSInvocation* invocation_;
}

- (NibwareNSOperation*) initWithObject:(id<NSObject>)object;
- (NibwareNSOperation*) initWithObject:(id<NSObject>)object selector:(SEL)sel args:(NSArray*)args;
- (NibwareNSOperation*) initWithObject:(id<NSObject>)object selector:(SEL)sel arg:(id)arg;

@end



@interface NibwareConcurrency : NSObject {

}



@end
