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
#import "Friend.h"
#import "SendGiftViewController.h"
#import "ModalPanelPickerView.h"
#import "FunctionObject.h"

@class ViewGiftViewController;
@protocol ViewGiftControllerDelegate <NSObject>

@optional
- (void)modalControllerDidFinish:(ViewGiftViewController*)modalController;
- (void)modalControllerDidFinish:(ViewGiftViewController*)modalController withBlock:(void(^)()) completion;

@end

@interface ViewGiftViewController : UIViewController 

@property (assign, nonatomic) id<ViewGiftControllerDelegate> delegate;
@property (strong, nonatomic) NSString * giftPath;
@property (strong, nonatomic) Friend *sender;
@property (nonatomic) BOOL preview;


@property (weak, nonatomic) IBOutlet UIView *viewGift;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrameCard;

@end
