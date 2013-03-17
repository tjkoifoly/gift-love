//
//  GiftItemManager.m
//  CardLove-v1
//
//  Created by FOLY on 3/16/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftItemManager.h"

@implementation GiftItemManager

@synthesize path = _path;
@synthesize listItems = _listItems;

+ (id)sharedManager
{
    static GiftItemManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[GiftItemManager alloc] init];
    });
    
    return __instance;
}

- (id)init {
    self = [super init];
    if (self) {
             
    }
    
    return self;
}


- (void)loadItems {
    _listItems = [NSKeyedUnarchiver unarchiveObjectWithFile:_path] ;
    if (!_listItems) {
        _listItems = [NSMutableArray array];
    }
}

- (NSArray *)getListItems {
    
    [self loadItems];
    
    return _listItems;
}

-(BOOL)saveList
{
    return [NSKeyedArchiver archiveRootObject:_listItems toFile:_path];
}

- (BOOL) saveList : (NSArray *) list toPath: (NSString *)path
{
    return [NSKeyedArchiver archiveRootObject:list toFile:path];
}

- (void) addItem: (GiftItem *)item
{
    [_listItems addObject:item];
    [self saveList];
}
- (void) removeItem: (GiftItem *)item
{
    [_listItems removeObject:item];
    [self saveList];
}


@end
