//
//  GiftLabelsManager.h
//  CardLove-v1
//
//  Created by FOLY on 3/28/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftLabel.h"

#define kGiftLabel @"gift-label.tjkoifoly"

@interface GiftLabelsManager : NSObject

@property (strong, nonatomic) NSString          *pathData;
@property (strong, nonatomic) NSMutableArray    *listLabels;

+ (id)sharedManager;

-(void) loadLabels;
-(NSArray *) getListLabels;
-(BOOL) saveListLabel;
-(void) addLabel : (GiftLabel *) gLabel;
-(void) removeLabel: (GiftLabel *) gLabel;

-(id) findLabelByID: (NSString *) lID;

@end
