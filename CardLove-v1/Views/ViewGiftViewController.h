//
//  ViewGiftViewController.h
//  CardLove-v1
//
//  Created by FOLY on 3/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewGiftViewController;
@protocol ViewGiftControllerDelegate <NSObject>

- (void)modalControllerDidFinish:(ViewGiftViewController*)modalController;

@end

@interface ViewGiftViewController : UIViewController

@property (assign, nonatomic) id<ViewGiftControllerDelegate> delegate;
@property (strong, nonatomic) NSString * giftName;

@end
