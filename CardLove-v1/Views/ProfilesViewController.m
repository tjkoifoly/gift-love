//
//  ProfilesViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ProfilesViewController.h"
#import "LoginViewController.h"
#import "DBSignupViewController.h"
#import "HMGLTransition.h"
#import "HMGLTransitionManager.h"
#import "DoorsTransition.h"
#import "RotateTransition.h"
#import "FlipTransition.h"
#import "UserManager.h"

@interface ProfilesViewController ()

@end

@implementation ProfilesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Profiles", @"Profiles");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnEdit setBackgroundImage:[UIImage imageNamed:@"Contacts.png"] forState:UIControlStateNormal];
//    btnEdit.frame = CGRectMake(0, 0, 30, 30);
//    [btnEdit addTarget:self action:@selector(editProfiles) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    UIBarButtonItem *btnEditProfile = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfiles)];
    self.navigationItem.rightBarButtonItem = btnEditProfile;
    
    [self loadInfo];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSString *strURL = [[UserManager sharedInstance] imgAvata];
    if (!strURL) {
        self.imvAvarta.image = [UIImage imageNamed:@"noavata.png"];
    }else
    {
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        UIImage *photo = [UIImage imageWithData:dataImage];
        if (photo) {
            [UIView animateWithDuration:0.1 animations:^{
                self.imvAvarta.alpha = 0;
            }completion:^(BOOL finished) {
                self.imvAvarta.image = photo;
                [UIView animateWithDuration:0.1 animations:^{
                    self.imvAvarta.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
        }else
        {
            self.imvAvarta.image = [UIImage imageNamed:@"noavata.png"];
        }
    }
    
    self.lbUserName.text = [[UserManager sharedInstance] displayName];
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    self.imvAvarta.image = [UIImage imageNamed:@"noavata.png"];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

-(void)editProfiles
{
    DBSignupViewController *epvc = [[DBSignupViewController alloc] initWithNibName:@"DBSignupViewController" bundle:nil];
    epvc.viewMode = ProfileViewTypeEdit;
    
    [self.navigationController pushViewController:epvc animated:YES];
    
    
    
}

- (void)viewDidUnload {
    [self setImvAvarta:nil];
    [self setLbUserName:nil];
    [super viewDidUnload];
}
- (IBAction)logout:(id)sender {

    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navLogin.navigationBarHidden = YES;
    
    RotateTransition *_transition = [[RotateTransition alloc] init];
    [[HMGLTransitionManager sharedTransitionManager] setTransition:_transition];
    [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:navLogin onViewController:self.navigationController];
    
}

-(void) loadInfo
{
    
}


@end
