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
    [self loadGiftByName:_giftName];
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

@end
