//
//  CreateAEventViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/16/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "CreateAEventViewController.h"

@interface CreateAEventViewController ()

@end

@implementation CreateAEventViewController

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
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCreate)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCreate)];
    self.navigationItem.rightBarButtonItem = btnDone;
}

-(void) cancelCreate
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneCreate
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
