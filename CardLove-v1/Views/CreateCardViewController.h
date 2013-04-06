//
//  CreateCardViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureImageView.h"
#import "AFPhotoEditorController.h"
#import "MBProgressHUD.h"
#import "REMenu.h"
#import "CMTextStylePickerViewController.h"
#import "GestureView.h"
#import "GestureLabel.h"
#import "GiftLabelsManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicViewController.h"
#import "AnimationsViewController.h"
#import "UIEffectDesignerView.h"

@interface CreateCardViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GesturePhotoDelegate, GestureViewDelegate, AFPhotoEditorControllerDelegate, MBProgressHUDDelegate, CMTextStylePickerViewControllerDelegate, GestureLabelDelegate, MusicViewControllerDelegate, AnimationViewControllerDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) REMenu *exportMenu;
@property (strong, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrameCard;
@property (weak, nonatomic) IBOutlet UIView *viewGift;

@property (strong, nonatomic) NSString *giftName;

@end
