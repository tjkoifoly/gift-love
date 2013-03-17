//
//  GHRootViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHRootViewController.h"
#import "GHPushedViewController.h"


#pragma mark -
#pragma mark Private Interface
@interface GHRootViewController ()
- (void)pushViewController;
- (void)revealSidebar;
@end


#pragma mark -
#pragma mark Implementation
@implementation GHRootViewController

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super init]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
														  target:self
														  action:@selector(revealSidebar)];
	}
	return self;
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock withNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(revealSidebar)];
	}
	return self;
}


#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

#pragma mark Private Methods
- (void)pushViewController {
	
}

- (void)revealSidebar {
	_revealBlock();
}

@end
