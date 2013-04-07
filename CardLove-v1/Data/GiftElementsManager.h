//
//  GiftElementsManager.h
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftElement.h"

@interface GiftElementsManager : NSObject

@property (strong, nonatomic) NSString *pathData;
@property (strong, nonatomic) NSMutableArray *listElenemts;

+ (id)sharedManager;

- (void)loadElements;
- (NSArray *)getListElements;
- (BOOL) saveListElements;
- (BOOL) saveListElements : (NSArray *) list toPath: (NSString *)path;
- (void) addElement: (GiftElement *)element;
- (void) removeElement: (GiftElement *)element;

-(id) findElementGiftByElementID: (NSString *) elementID;


@end
