//
//  NibwareBase.h
//  pingle
//
//  Created by robertsanders on 5/25/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//


#define NW_UNIMPLEMENTED()    [NSException raise:@"Unimplemented" format:@"Function [%@ %@] is not implemented", \
                                 NSStringFromClass([self class]), NSStringFromSelector(_cmd)];


