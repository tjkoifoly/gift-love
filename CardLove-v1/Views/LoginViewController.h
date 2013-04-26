//
//  LoginViewController.h
//  CardLove-v1
//
//  Created by FOLY on 3/4/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet BButton *btnLogin;
@property (weak, nonatomic) IBOutlet BButton *btnSignUp;
@property (nonatomic) BOOL startFlag;

- (IBAction)login:(id)sender ;

@end
