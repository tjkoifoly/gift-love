//
//  RequestsManager.h
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

@interface RequestsManager : NSObject

@property (strong, nonatomic) NSMutableArray *listRequests;

@property (unsafe_unretained, nonatomic) UIView *viewContainer;

+ (id)sharedManager;

-(void) resetData;

-(void) loadRequest: (NSString*)userID completion:(CompletionBlockWithResult)completionBlock;

@end
