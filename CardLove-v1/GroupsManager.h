//
//  GroupsManager.h
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

@interface GroupsManager : NSObject

@property (unsafe_unretained, nonatomic) UIView *viewContainer;

@property (strong, nonatomic) NSMutableArray *listGroups;
@property (strong, nonatomic) NSMutableArray *listMessages;
@property ( nonatomic) BOOL firstLoad;

+ (id)sharedManager;
-(void) resetData;

-(void) loadGroupsByMember: (NSString*)memberID completion:(CompletionBlockWithResult)completionBlock;

@end
