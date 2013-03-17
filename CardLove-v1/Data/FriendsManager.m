//
//  FriendsManager.m
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendsManager.h"

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
        
        //LOG
        //NSLog(@"Saving friends in %@", _path);
    
//        Friend *friend = [[Friend alloc] init];
//        friend.displayName = @"CongNC";
//        friend.userName = @"foly";
//        
//        Friend *friend2 = [[Friend alloc] init];
//        friend2.displayName = @"TuyenVT";
//        friend2.userName = @"tjkoi";
//        
//        Friend *friend3 = [[Friend alloc] init];
//        friend3.displayName = @"HuongNT";
//        friend3.userName = @"nuhoangtuyet";
//        
//        Friend *friend4 = [[Friend alloc] init];
//        friend4.displayName = @"KengKeng";
//        friend4.userName = @"kengkeng";
//        
//        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:friend,friend2,friend3, friend4, nil];
//        
//        [NSKeyedArchiver archiveRootObject:array toFile:_path];
       
    }
    
    return self;
}

- (void)loadFriends {
    _friendsList = [NSKeyedUnarchiver unarchiveObjectWithFile:_path] ;
    if (!_friendsList) {
        _friendsList = [NSMutableArray array];
    }
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





@end
