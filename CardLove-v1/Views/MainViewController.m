//
//  MainViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "MainViewController.h"
#import "FriendsViewController.h"
#import "NewsViewController.h"
#import "CardsViewController.h"
#import "SettingsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self initComponents];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) initComponents
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    FriendsViewController *fvc = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
    fvc.tabBarItem.image = [UIImage imageNamed:@"friends.png"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fvc];
    [nav1 setNavigationBarHidden:YES];
    [controllers addObject:nav1];
    
    NewsViewController *nvc = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    nvc.tabBarItem.image = [UIImage imageNamed:@"news.png"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:nvc];
    [nav2 setNavigationBarHidden:YES];
    [controllers addObject:nav2];
    
    CardsViewController *cvc = [[CardsViewController alloc] initWithNibName:@"CardsViewController" bundle:nil];
    cvc.tabBarItem.image = [UIImage imageNamed:@"cards.png"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:cvc];
    [nav3 setNavigationBarHidden:YES];
    [controllers addObject:nav3];
    
    self.viewControllers = controllers;
    self.customizableViewControllers = controllers;
    [self setSelectedViewController:nav1];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
