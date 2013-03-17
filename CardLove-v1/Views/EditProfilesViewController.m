//
//  EditProfilesViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/4/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "EditProfilesViewController.h"

@interface EditProfilesViewController ()

@end

@implementation EditProfilesViewController

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
    
    self.navigationItem.title = @"Edit Profiles";
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveProfilesDone)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

-(void) backPreviousView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

-(void)saveProfilesDone
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveProfiles
{
    NSLog(@"Saved here.");
}

-(void) resignKeyboard : (id) sender
{
    [sender resignFirstResponder];
}

@end
