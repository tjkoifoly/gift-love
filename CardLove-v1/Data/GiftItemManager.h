//
//  GiftItemManager.h
//  CardLove-v1
//
//  Created by FOLY on 3/16/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftItem.h"

@interface GiftItemManager : NSObject

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSMutableArray *listItems;

+ (id)sharedManager;

- (void)loadItems;
- (NSArray *)getListItems;
- (BOOL) saveList;
- (BOOL) saveList : (NSArray *) list toPath: (NSString *)path;
- (void) addItem: (GiftItem *)item;
- (void) removeItem: (GiftItem *)item;


@end
