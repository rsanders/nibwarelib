//
//  NibwarePrefs.m
//  pingle
//
//  Created by Robert Sanders on 9/23/08.
//  Copyright 2008 ViTrue, Inc.. All rights reserved.
//

#import "Nibware.h"
#import "NibwarePrefs.h"

@implementation NibwarePrefs


@end


@implementation NSUserDefaults (Nibware)   

- (void) setValueByParsedString:(NSString *)value forKey:(NSString *)key
{
    id current = [self objectForKey:key];
    NSString *clazzName = NSStringFromClass([current class]);
    NSLog(@"current value for %@ is class %@", key, [value class]);
    if ([clazzName isEqualToString:@"NSCFBoolean"] 
        || [value isEqualToString:@"t"]
        || [value isEqualToString:@"f"]
        || [value isEqualToString:@"Y"]
        || [value isEqualToString:@"N"]        
        ) 
    {
        NSLog(@"setting boolean to value %d", [value boolValue]);
        [self setBool:[value boolValue] forKey:key];
    }
    else {
        [self setObject:value forKey:key];
    }
}

- (void) setFromDictionary:(NSDictionary *)dict overwrite:(BOOL)overwrite
{
    NSLog(@"NIBWARE: setting preferences from dict %@", dict);
    
    for (NSString *key in [dict keyEnumerator]) {
        if (!overwrite && [self objectForKey:key]) {
            continue;
        }
        NSString *val = [dict valueForKey:key];
        
        NSLog(@"setting config for %@ to %@", key, val);
        

        [self setValueByParsedString:val forKey:key];
    }
}

- (void) setFromDictionary:(NSDictionary *)dict
{
    [self setFromDictionary:dict overwrite:YES];
}

- (void) copyFromDictionary:(NSDictionary*)dict overwrite:(BOOL)overwrite
{
    for (NSString *key in [dict keyEnumerator]) {
        if (!overwrite && [self objectForKey:key]) {
            continue;
        }
        [self setValue:[dict valueForKey:key] forKey:key];
    }
}


@end
