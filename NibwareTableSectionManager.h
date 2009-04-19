//
//  NibwareTableSectionManager.h
//  pingle
//
//  Created by robertsanders on 1/19/09.
//  Copyright 2009 Robert Sanders. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NibwareSectionFunction <NSObject>
- (NSString*) sectionForObject:(id)object;
@end

@interface NibwareTableSection : NSObject {
    NSString*                      sectionName;
    NSMutableArray*                items;
}

@property (retain)  NSString*                      sectionName;
@property (retain)  NSMutableArray*                items;

- (NibwareTableSection*) initWithSectionName:(NSString*)name;
- (void) addObject:(id<NSObject>) item;
- (id) objectAtIndex:(NSInteger)index;

@end

@interface NibwareTableSectionManager : NSObject {
    NSMutableArray*                sections;
    id<NibwareSectionFunction>     sectionFunction;
    NibwareTableSection*           defaultSection;
}

@property (retain) id<NibwareSectionFunction>     sectionFunction;
@property (readonly) NSMutableArray*              sections;

- (NibwareTableSectionManager*) initWithSectionFunction:(id<NibwareSectionFunction>)function;
- (void) reset;
- (void) sectionalize:(NSArray*)items;

- (NSInteger) sectionCount;
- (NibwareTableSection*) sectionByIndex:(NSInteger)num;
- (NibwareTableSection*) sectionByName:(NSString *)name;

// uitableviewdatasource-like methods
- (id) objectForIndexPath:(NSIndexPath*) path;
- (NSIndexPath*) indexPathForObject:(id<NSObject>)object;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString*)tableView:(UITableView*)table titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;

@end
