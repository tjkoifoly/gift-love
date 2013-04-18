//
//  LoginViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/4/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HMGLTransitionManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassword:nil];
    [self setBtnLogin:nil];
    [self setBtnSignUp:nil];
    [super viewDidUnload];
}
- (IBAction)signUp:(id)sender {
    
        
}
- (IBAction)login:(id)sender {
    NSString *userName = [_txtUserName text];
    NSString *passWord = [_txtPassword text];
    
    if ([userName isEqualToString:@"foly"] && [passWord isEqualToString:@"tjkoi"]) {
        [[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:self];
    }else
    {
        //Notification errors
    }

    
}
@end
