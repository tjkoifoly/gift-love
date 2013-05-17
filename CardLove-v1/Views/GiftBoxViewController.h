//
//  GiftBoxViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"
#import "CardsViewController.h"
#import "StoredCardsViewController.h"
#import "ViewGiftViewController.h"
#import "HMGLTransitionManager.h"
#import "DoorsTransition.h"

@interface GiftBoxViewController : UITabBarController <CardViewControllerDelegate, ViewGiftControllerDelegate, StoreCardViewControllerDelegate, UITabBarControllerDelegate>
{
@private
	RevealBlock _revealBlock;
}

@property (nonatomic, strong) HMGLTransition *transition;
@property (nonatomic) NavigationBarMode mode;

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

@end
