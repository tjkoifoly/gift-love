//
//  ViewGiftViewController.h
//  CardLove-v1
//
//  Created by FOLY on 3/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftItemManager.h"
#import "GiftLabelsManager.h"
#import "GiftElementsManager.h"
#import "GestureImageView.h"
#import "GestureView.h"
#import "GestureLabel.h"
#import "MacroDefine.h"
#import "UIEffectDesignerView.h"
#import "ZipArchive.h"
#import "FunctionObject.h"

@class ViewGiftViewController;
@protocol ViewGiftControllerDelegate <NSObject>

- (void)modalControllerDidFinish:(ViewGiftViewController*)modalController;

@end

@interface ViewGiftViewController : UIViewController 

@property (assign, nonatomic) id<ViewGiftControllerDelegate> delegate;
@property (strong, nonatomic) NSString * giftPath;


@property (weak, nonatomic) IBOutlet UIView *viewGift;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrameCard;

@end
