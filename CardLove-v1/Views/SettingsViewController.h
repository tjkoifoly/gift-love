//
//  SettingsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"
#import "IASKAppSettingsViewController.h"

@interface SettingsViewController : GHRootViewController<IASKSettingsDelegate>
{
    IASKAppSettingsViewController *appSettingsViewController;
}

@property (nonatomic, strong) IASKAppSettingsViewController *appSettingsViewController;

@end
