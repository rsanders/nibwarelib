//
//  NibwareTableSectionManager.m
//  pingle
//
//  Created by robertsanders on 1/19/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import "NibwareTableSectionManager.h"

@implementation NibwareTableSection
@synthesize sectionName, items;

- (NibwareTableSection*) initWithSectionName:(NSString*)name 
{
    self = [super init];
    self.sectionName = name;
    self.items = [NSMutableArray array];
    return self;
}

- (void) addObject:(id<NSObject>) item
{
    [self.items addObject:item];
}

- (id) objectAtIndex:(NSInteger)index
{
    if (items.count > index) {
        return [items objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void) dealloc
{
    self.sectionName = self.items = nil;
    [super dealloc];
}
@end

@interface NibwareSectionSelector : NSObject <NibwareSectionFunction> {
    SEL  _selector;
}
@end

@implementation NibwareSectionSelector
- (NibwareSectionSelector*) initWithSelector:(SEL)selector {
    self = [super init];
    _selector = selector;
    return self;
}
- (NSString*) sectionForObject:(id)object {
    return (NSString *)[object performSelector:_selector];
}
@end

@implementation NibwareTableSectionManager
@synthesize sectionFunction, sections;

- (id<NibwareSectionFunction>) functionForSelector:(SEL)selector
{
    return [[[NibwareSectionSelector alloc] initWithSelector:selector] autorelease];
}

- (NibwareTableSectionManager*) init
{
    self = [super init];
    sections = [[NSMutableArray alloc] init];
    defaultSection = [[NibwareTableSection alloc] initWithSectionName:@"All"];
    return self;
}

- (NibwareTableSectionManager*) initWithSectionFunction:(id<NibwareSectionFunction>)function
{
    self = [self init];
    self.sectionFunction = function;
    return self;
}

- (NibwareTableSectionManager*) initWithSectionSelector:(SEL)selector
{
    self = [self init];
    self.sectionFunction = [self functionForSelector:selector];
    return self;
}

- (NibwareTableSection*) getSection:(NSString *)name create:(BOOL)create
{
    NibwareTableSection *section = nil;
    for (section in self.sections) {
        if ([section.sectionName isEqualTo:name]) {
            return section;
        }
    }
    if (create) {
        section = [[NibwareTableSection alloc] initWithSectionName:name];
        [self.sections addObject:section];
    }
    return section;
}

- (void) sectionalize:(NSArray*)items
{
    for (id<NSObject> item in items)
    {
        NSString *name = [sectionFunction sectionForObject:item];
        NibwareTableSection *section = [self getSection:name create:YES];
        [section addObject:item];
    }
}

- (NSInteger) sectionCount {
    return fmax([sections count], 1);
}

- (NibwareTableSection*) sectionByIndex:(NSInteger)num {
    if (sections.count > num) {
        return [sections objectAtIndex:num];
    } else {
        return defaultSection;
    }
}

- (NibwareTableSection*) sectionByName:(NSString *)name {
    return [self getSection:name create:NO];
}

- (id) objectForIndexPath:(NSIndexPath*) path {
    NibwareTableSection *section = [self sectionByIndex:path.section];
    return [section objectAtIndex:path.row];
}

- (void) dealloc
{
    self.sectionFunction = nil;
    [defaultSection release];
    [sections release];
    [super dealloc];
}

@end
