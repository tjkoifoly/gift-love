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

@interface CreateCardViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GesturePhotoDelegate, GestureViewDelegate, AFPhotoEditorControllerDelegate, MBProgressHUDDelegate, CMTextStylePickerViewControllerDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) REMenu *exportMenu;
@property (strong, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIView *viewCard;

@end
