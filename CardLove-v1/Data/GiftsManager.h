//
//  GiftsManager.h
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

@interface GiftsManager : NSObject

@property (strong, nonatomic) NSMutableArray *listSentGifts;
@property (strong, nonatomic) NSMutableArray *listRecievedGifts;

@property (unsafe_unretained, nonatomic) UIView *viewContainer;

+ (id)sharedManager;

-(void) loadGiftbyUser: (NSString*)userID completion:(void (^)(BOOL success, NSError *error, id result))completionBlock;

@end
