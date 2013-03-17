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

@interface CreateCardViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GesturePhotoDelegate, AFPhotoEditorControllerDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIView *viewCard;

@end
