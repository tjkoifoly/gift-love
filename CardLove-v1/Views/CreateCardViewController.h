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
#import "GiftElement.h"
#import "GiftElementsManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicViewController.h"
#import "AnimationsViewController.h"
#import "UIEffectDesignerView.h"
#import "PromptAlert.h"
#import "GiftElementsViewController.h"
#import "HMGLTransitionManager.h"
#import "DoorsTransition.h"
#import "ViewGiftViewController.h"
#import "TapkuLibrary.h"
#import "ConfigurationViewController.h"
#import "ViewStyle.h"
#import "FunctionObject.h"
#import "ModalPanelPickerView.h"
#import "SendGiftViewController.h"


@interface CreateCardViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GesturePhotoDelegate, GestureViewDelegate, AFPhotoEditorControllerDelegate, MBProgressHUDDelegate, CMTextStylePickerViewControllerDelegate, GestureLabelDelegate, MusicViewControllerDelegate, AnimationViewControllerDelegate, GiftElementsDelegate, ViewGiftControllerDelegate, ViewStyleDelegate, ModalPanelDelegate, SendGiftViewControllerDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) REMenu *exportMenu;
@property (strong, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrameCard;
@property (weak, nonatomic) IBOutlet UIView *viewGift;

@property (strong, nonatomic) NSString *giftName;
@property (strong, nonatomic) NSString *giftPath;
@property (nonatomic) BOOL edit;


@end
