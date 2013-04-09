//
//  StoredCardsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCollectionViewController.h"
#import "MacroDefine.h"
#import "CreateCardViewController.h"

@class StoredCardsViewController;
@protocol StoreCardViewControllerDelegate <NSObject>

-(void) storeCardViewControllerGiftDidSelected: (NSString *) giftPath;

@end

@interface StoredCardsViewController : SSCollectionViewController

@property (strong, nonatomic) NSMutableArray *listGifts;
@property (assign, nonatomic) id<StoreCardViewControllerDelegate> delegate;
@property (nonatomic) NavigationBarMode mode;

-(void) editDone;

@end
