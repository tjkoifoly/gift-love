//
//  ProfilesViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"

@interface ProfilesViewController : GHRootViewController

@property (weak, nonatomic) IBOutlet UIImageView *imvAvarta;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
- (IBAction)logout:(id)sender;

@end
