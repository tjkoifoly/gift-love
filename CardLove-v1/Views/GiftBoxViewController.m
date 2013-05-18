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
{
    CardsViewController *cvc;
    StoredCardsViewController *fvc;
}

@end

@implementation GiftBoxViewController

@synthesize transition = _transition;
@synthesize mode = _mode;

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
        
        [self switchBartToMode:NavigationBarModeView];
        
	}
	return self;
}

-(void) switchBartToMode:(NavigationBarMode) mode
{
    _mode = mode;
    cvc.mode = mode;
    fvc.mode = mode;
    
    switch (mode) {
        case NavigationBarModeEdit:
        {
            UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone   target:self action:@selector(doneEdit:)];
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnDone, nil] animated:YES];
            
//            CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//            fadeOutAnimation.duration = 0.5f;
//            fadeOutAnimation.removedOnCompletion = NO;
//            fadeOutAnimation.fillMode = kCAFillModeForwards;
//            fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0f];
//            [viewToAnimation.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
            
        }
            break;
        case NavigationBarModeView:
        {
            UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addCard)];
            UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCard:)];
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnNew ,btnDelete, nil] animated:YES] ;
        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _transition = [[DoorsTransition alloc] init];
}

-(void) initComponents
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    cvc = [[CardsViewController alloc] initWithNibName:@"CardsViewController" bundle:nil];
    cvc.delegate = self;
    cvc.tabBarItem.image = [UIImage imageNamed:@"cards.png"];
    cvc.tabBarItem.title = @"Box Created";
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:cvc];
    [nav3 setNavigationBarHidden:YES];
    [controllers addObject:nav3];
    
    fvc = [[StoredCardsViewController alloc] initWithNibName:@"StoredCardsViewController" bundle:nil];
    fvc.delegate = self;
    fvc.tabBarItem.image = [UIImage imageNamed:@"Stored.png"];
    fvc.tabBarItem.title = @"Box Saved";
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fvc];
    [nav1 setNavigationBarHidden:YES];
    [controllers addObject:nav1];
    
    self.viewControllers = controllers;
    self.customizableViewControllers = controllers;
    [self setSelectedViewController:nav3];
    self.delegate = self;
}

-(void) viewDidUnload
{
    [self setTransition:nil];
    [super viewDidUnload];
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
    [self switchBartToMode:NavigationBarModeEdit];
}

-(void) saveCard
{
    NSLog(@"Save Card");
}

-(void) doneEdit: (id) sender
{
    NSLog(@"Done");
    [self switchBartToMode:NavigationBarModeView];
    [cvc editDone];
    [fvc editDone];
}
-(void) createCard
{
    CreateCardViewController *ccvc = [[CreateCardViewController alloc] initWithNibName:@"CreateCardViewController" bundle:nil];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ccvc animated:YES];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
}
#pragma mark - CardView Delegate

-(void) cardViewControllerDidSelected:(NSString *)giftName
{
    [self viewGiftCardWithPath:giftName];
}

-(void) viewGiftCardWithPath: (NSString *) path
{
    ViewGiftViewController *cvcv = [[ViewGiftViewController alloc] initWithNibName:@"ViewGiftViewController" bundle:nil];
    cvcv.giftPath = path;
    cvcv.delegate = self;
    
    [[HMGLTransitionManager sharedTransitionManager] setTransition:_transition];
    [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:cvcv onViewController:self.navigationController];
    
}

#pragma mark - ViewGift Delegate
-(void) modalControllerDidFinish:(ViewGiftViewController *)modalController
{
    [[HMGLTransitionManager sharedTransitionManager] setTransition:_transition];
	[[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:modalController];
}

#pragma mark - StoreCardDelegate
-(void) storeCardViewControllerGiftDidSelected:(NSString *)giftPath
{
    [self viewGiftCardWithPath:giftPath];
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (_mode == NavigationBarModeEdit) {
        [self switchBartToMode:NavigationBarModeView];
    }

}


@end
