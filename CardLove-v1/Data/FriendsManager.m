//
//  FriendsManager.m
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendsManager.h"
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"

@implementation FriendsManager

@synthesize path = _path;
@synthesize friendsList = _friendsList;

+(id)sharedManager
{
    static FriendsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[FriendsManager alloc] init];
    });
    
    return __instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *documentsDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        _path = [documentsDirectory stringByAppendingPathComponent:@"friends.dat"] ;
    }
    
    return self;
}

- (void)loadFriends {
    //_friendsList = [NSKeyedUnarchiver unarchiveObjectWithFile:_path] ;
    if (!_friendsList) {
        _friendsList = [NSMutableArray array];
    }
}

-(void) loadFriendsFromURLbyUser: (NSString*)userID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"sourceID", nil];
    [[NKApiClient shareInstace] postPath:@"list_friend.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Friend = %@", jsonObject);
        if (_friendsList) {
            [_friendsList removeAllObjects];
        }
        for(NSDictionary *dictFriend in jsonObject)
        {
            Friend *aFriend =  [[Friend alloc]initWithDictionary:dictFriend];
            [self addFriend:aFriend];
        }
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

- (NSArray *)friendsList {
    if (!_friendsList) {
        [self loadFriends];
    }
    return _friendsList;
}

-(void)saveList : (NSArray *) list toFilePath: (NSString *)path
{
    [NSKeyedArchiver archiveRootObject:list toFile:path];
}

- (void)addFriend:(Friend *)fO {
    if (!_friendsList)
        [self loadFriends];
    
    [_friendsList addObject:fO];
    
    [self saveList:_friendsList toFilePath:_path];
}

-(void) removeFriend:(Friend *)fO
{
    if (!_friendsList) {
        [_friendsList removeObject:fO];
    }
    [self saveList:_friendsList toFilePath:_path];
}

-(void) removeFriendAtIndex:(NSUInteger)index
{
    if(index < [_friendsList count])
    {
        [_friendsList removeObjectAtIndex:index];
    }
    [self saveList:_friendsList toFilePath:_path];
    
}

-(id) findFriendByName: (NSString *) fName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", kAccName , fName];
    NSMutableArray *result = [NSMutableArray arrayWithArray:_friendsList];
    [result filterUsingPredicate:predicate];
    
    if ([result count] == 0) {
        return nil;
    }
    return [result objectAtIndex:0];
    
}

- (BOOL)personExists:(NSString *)key withValue:(NSString *)value {
    
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@", key, value];
    NSUInteger index = [self.friendsList indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    
    if (index == NSNotFound) {
        return NO;
    }
    
    return YES;
}

-(Friend *) friendByName: (NSString *)fName
{
    
    for (Friend *f in _friendsList)
    {

        if ([f.userName isEqualToString:fName]) {
            return f;
            
        }else{
            continue;
        }
    }
    return nil;
}

-(Friend *) friendByID: (NSString *)fID
{
    
    for (Friend *f in _friendsList)
    {
        
        if ([f.fID isEqualToString:fID]) {
            return f;
            
        }else{
            continue;
        }
    }
    return nil;
}

-(NSString *) friendNameByID: (NSString *)fID
{
    for (Friend *f in _friendsList)
    {
        
        if ([f.fID isEqualToString:fID]) {
            return f.userName;
            
        }else{
            continue;
        }
    }
    return nil;

}

-(NSArray *) listFriendLikeName: (NSString *)fSearch
{
    NSMutableArray *temArray = [[NSMutableArray alloc] init];
    for (Friend *f in _friendsList)
    {
        
        if ([f.userName hasPrefix:fSearch]) {
            [temArray addObject:f];
            
        }else{
            continue;
        }
    }
    return temArray;
    
}


@end
