//
//  CardsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMTabView.h"
#import "GHRootViewController.h"
#import "SSCollectionViewController.h"
#import "MacroDefine.h"
#import "CreateCardViewController.h"

@class CardsViewController;
@protocol CardViewControllerDelegate <NSObject>

-(void) cardViewControllerDidSelected: (NSString *)giftName;

@end

@interface CardsViewController : SSCollectionViewController <JMTabViewDelegate>

@property (assign, nonatomic) id <CardViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *listGifts;

@end
