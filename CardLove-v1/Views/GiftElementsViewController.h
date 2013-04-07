//
//  GiftElementsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftElementsViewController;
@protocol GiftElementsDelegate <NSObject>

-(void) giftElementsViewControllerDidSelected: (NSString *) elementName;

@end

@interface GiftElementsViewController : UIViewController

@property (strong, nonatomic) id<GiftElementsDelegate> delegate;


@end
