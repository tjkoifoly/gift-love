//
//  GiftBoxViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftBoxViewController.h"
#import "CardsViewController.h"
#import "StoredCardsViewController.h"
#import "CreateCardViewController.h"

@interface GiftBoxViewController ()

@end

@implementation GiftBoxViewController

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

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        [self initComponents];
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(revealSidebar)];
        
        UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addCard)];
        UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCard:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnNew ,btnDelete, nil];
        
        
//        UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCard)];
//        NSArray *arrBarButtons = [NSArray arrayWithObjects:btnNew,btnSave, nil];
//        self.navigationItem.rightBarButtonItems = arrBarButtons;
        
//        UIButton *btnAddGift = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnAddGift setBackgroundImage:[UIImage imageNamed:@"add-gift.png"] forState:UIControlStateNormal];
//        btnAddGift.frame = CGRectMake(0, 0, 30, 30);
//        [btnAddGift addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddGift];
        
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
    
    CardsViewController *cvc = [[CardsViewController alloc] initWithNibName:@"CardsViewController" bundle:nil];
    cvc.delegate = self;
    cvc.tabBarItem.image = [UIImage imageNamed:@"cards.png"];
    cvc.tabBarItem.title = @"Inbox";
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:cvc];
    [nav3 setNavigationBarHidden:YES];
    [controllers addObject:nav3];
    
    StoredCardsViewController *fvc = [[StoredCardsViewController alloc] initWithNibName:@"StoredCardsViewController" bundle:nil];
    fvc.tabBarItem.image = [UIImage imageNamed:@"Stored.png"];
    fvc.tabBarItem.title = @"Stored";
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fvc];
    [nav1 setNavigationBarHidden:YES];
    [controllers addObject:nav1];
    
    self.viewControllers = controllers;
    self.customizableViewControllers = controllers;
    [self setSelectedViewController:nav3];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealSidebar {
	_revealBlock();
}

-(void) addCard
{
    NSLog(@"ADD CARD");
    [self createCard];
}

-(void) deleteCard: (id) sender
{
    NSLog(@"Delete Card");
}

-(void) saveCard
{
    NSLog(@"Save Card");
}

-(void) createCard
{
    CreateCardViewController *ccvc = [[CreateCardViewController alloc] initWithNibName:@"CreateCardViewController" bundle:nil];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ccvc animated:YES];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
}

-(void) cardViewControllerDidSelected:(NSString *)giftName
{
//    CreateCardViewController *ccvc = [[CreateCardViewController alloc] initWithNibName:@"CreateCardViewController" bundle:nil];
//    ccvc.giftName = giftName;
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:ccvc animated:YES];
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self viewGiftCard];
}

-(void) viewGiftCard
{
    CGPoint point = CGPointMake(320/2, 416/2);
    ViewGiftViewController *cvcv = [[ViewGiftViewController alloc] initWithNibName:@"ViewGiftViewController" bundle:nil];
    [[self navigationController] kt_pushViewController:cvcv explodeFromPoint:point];
}

@end
