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
@synthesize delegate;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    self.viewCard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cover-01.png"]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Update View
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self loadGiftByName:_giftName];
}

-(void) backPreviousView
{
    [self.delegate modalControllerDidFinish:self];
}

-(void) loadGiftByName: (NSString *) nameOfGift
{
    
}

-(void) viewDidUnload
{
    [self setGiftName:nil];
    [self setViewGift:nil];
    [self setViewCard:nil];
    [self setImvFrameCard:nil];
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
