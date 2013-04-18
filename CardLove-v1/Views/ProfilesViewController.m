//
//  ProfilesViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ProfilesViewController.h"
#import "EditProfilesViewController.h"
#import "LoginViewController.h"
#import "DBSignupViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

-(void)editProfiles
{
    EditProfilesViewController *epvc = [[EditProfilesViewController alloc] initWithNibName:@"EditProfilesViewController" bundle:nil];
    
    [self.navigationController pushViewController:epvc animated:YES];
    
}

- (void)viewDidUnload {
    [self setImvAvarta:nil];
    [self setLbUserName:nil];
    [super viewDidUnload];
}
- (IBAction)logout:(id)sender {
    
    //Logout Method
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navLogin =[[UINavigationController alloc] initWithRootViewController:loginVC];
    navLogin.navigationBarHidden = YES;
    
    [self presentModalViewController:navLogin animated:YES];
    
    
}
@end
