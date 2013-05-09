//
//  FriendsManager.h
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

@interface FriendsManager : NSObject

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSMutableArray *friendsList;

+ (id)sharedManager;

- (void)loadFriends;
-(void) loadFriendsFromURLbyUser: (NSString*)userID completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (NSArray *)friendsList;
- (void) addFriend : (Friend *) fO;
- (void) removeFriend :(Friend *) fO;
- (void) removeFriendAtIndex: (NSUInteger) index;

@end
