//
//  SettingsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize appSettingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", @"Settings");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    IASKAppSettingsViewController *settingsControler = [self appSettingsViewController];

    [self.view addSubview:settingsControler.view];
    
    CGRect frame = [settingsControler.view frame];
    frame.origin.y = 0;
    [settingsControler.view setFrame:frame];
   
    
}

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
		appSettingsViewController.delegate = self;
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
		appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
        
	}else
    {
        [appSettingsViewController reloadInputViews];
    }
	return appSettingsViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload
{
    [self setAppSettingsViewController:nil];
    [super viewDidUnload];
}


#pragma mark kIASKAppSettingChanged notification
- (void)settingDidChange:(NSNotification*)notification {
	if ([notification.object isEqual:@"AutoConnect"]) {
		BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"AutoConnect"] intValue];
		[appSettingsViewController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil] animated:YES];
	}
}

#pragma mark - SettingsDelegate
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender
{
    
}

@end
