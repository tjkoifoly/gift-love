//
//  GiftLabelsManager.m
//  CardLove-v1
//
//  Created by FOLY on 3/28/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftLabelsManager.h"

@implementation GiftLabelsManager

@synthesize pathData    = _pathData;
@synthesize listLabels  = _listLabels;

+ (id)sharedManager
{
    static GiftLabelsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[GiftLabelsManager alloc] init];
    });
    
    return __instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loadLabels {
    _listLabels = [NSKeyedUnarchiver unarchiveObjectWithFile:_pathData] ;
    if (!_listLabels) {
        _listLabels = [NSMutableArray array];
    }
}

- (NSArray *)getListLabels {
    
    [self loadLabels];
    
    return _listLabels;
}

-(BOOL)saveListLabel
{
    NSLog(@"Save data: %@ to path : %@", _listLabels, _pathData );
    return [NSKeyedArchiver archiveRootObject:_listLabels toFile:_pathData];
}

-(BOOL) saveNewListLabel: (NSArray *) list toPath: (NSString *) path
{
    return [NSKeyedArchiver archiveRootObject:list toFile:path];
}

-(void) addLabel : (GiftLabel *) gLabel
{
    [_listLabels addObject:gLabel];
    NSLog(@"ARRAY = %@", _listLabels);
    [self saveListLabel];

}

-(void) removeLabel: (GiftLabel *) gLabel
{
    [_listLabels removeObject:gLabel];
    [self saveListLabel];
}

-(id) findLabelByID: (NSString *) lID;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", klabelID, lID];
    NSMutableArray *result = [NSMutableArray arrayWithArray:_listLabels];
    [result filterUsingPredicate:predicate];
    
    if ([result count] == 0) {
        return nil;
    }
    return [result objectAtIndex:0];
    
}


@end
