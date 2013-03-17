//
//  GiftBoxViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"

@interface GiftBoxViewController : UITabBarController
{
@private
	RevealBlock _revealBlock;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

@end
