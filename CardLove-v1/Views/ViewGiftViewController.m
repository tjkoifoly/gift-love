//
//  ViewGiftViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ViewGiftViewController.h"

@interface ViewGiftViewController ()

@end

@implementation ViewGiftViewController

@synthesize giftName = _giftName;

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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(160, 200, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    [self loadGiftByName:_giftName];
    
}

-(void) backPreviousView
{
    CGPoint point = CGPointMake(320/2, 416/2);
    [[self navigationController] kt_popViewControllerImplodeToPoint:point];
}

-(void) loadGiftByName: (NSString *) nameOfGift
{
    
}

-(void) viewDidUnload
{
    [self setGiftName:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeViewGiftController:(id)sender {
    [self backPreviousView];
}

@end
