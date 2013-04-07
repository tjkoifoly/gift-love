//
//  GiftElementsManager.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftElementsManager.h"

@implementation GiftElementsManager

+ (id)sharedManager
{
    static GiftElementsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[GiftElementsManager alloc] init];
    });
    
    return __instance;
}

- (void)loadElements
{
    _listElenemts = [NSKeyedUnarchiver unarchiveObjectWithFile:_pathData] ;
    if (!_listElenemts) {
        _listElenemts = [NSMutableArray array];
    }
}
- (NSArray *)getListElements
{
    [self loadElements];
    return _listElenemts;
}
- (BOOL) saveListElements
{
    return [NSKeyedArchiver archiveRootObject:_listElenemts toFile:_pathData];
}
- (BOOL) saveListElements : (NSArray *) list toPath: (NSString *)path
{
    return [NSKeyedArchiver archiveRootObject:list toFile:path];
}
- (void) addElement: (GiftElement *)element
{
    [_listElenemts addObject:element];
    [self saveListElements];
}
- (void) removeElement: (GiftElement *)element
{
    [_listElenemts removeObject:element];
    [self saveListElements];
}

-(id) findElementGiftByElementID: (NSString *) elementID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", kElementID, elementID];
    NSMutableArray *result = [NSMutableArray arrayWithArray:_listElenemts];
    [result filterUsingPredicate:predicate];
    
    if ([result count] == 0) {
        return nil;
    }
    return [result objectAtIndex:0];
}

@end
