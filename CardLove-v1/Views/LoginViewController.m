//
//  LoginViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/4/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HMGLTransitionManager.h"
#import "DoorsTransition.h"
#import "DBSignupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "NKApiClient.h"
#import "JSONKit.h"
#import "UserManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize startFlag = _startFlag;

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
    [_btnLogin setType:BButtonTypePrimary];
    [_btnSignUp setType:BButtonTypeDanger];
    
    //Data
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"];
    _txtUserName.text = userName;
    _txtPassword.text = passWord;
    
    if (_startFlag) {
        BOOL autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"autologin_preference"];
        
        NSLog(@"AUTO = %i", autoLogin);
        if (autoLogin) {
            [self login:nil];
        }

    }
    
    //Listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupAccountSuccessful:) name:kNotificationSignUpSuccessful object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassword:nil];
    [self setBtnLogin:nil];
    [self setBtnSignUp:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationSignUpSuccessful object:nil];
    [super viewDidUnload];
}
#pragma mark - 

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y -= kbSize.height/3+10;
        self.view.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y += kbSize.height/3+10;
        self.view.frame = frame;

    } completion:^(BOOL finished) {
        
    }];
}

-(void) applicationDidBecomeActive
{
    BOOL autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"autologin_preference"];
    
    NSLog(@"AUTO = %i", autoLogin);
    if (autoLogin) {
        [self login:_btnLogin];
    }
}

-(IBAction)resignKeyboard : (id) sender
{
    if ([sender isEqual:_txtUserName]) {
        [_txtPassword becomeFirstResponder];
    }else
    {
        [_txtPassword resignFirstResponder];
    }
}


#pragma mark - IBActions
- (IBAction)signUp:(id)sender {
    DBSignupViewController *signUpVC = [[DBSignupViewController alloc] initWithNibName:@"DBSignupViewController" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
    
}
- (IBAction)login:(id)sender {
    
    [_txtPassword resignFirstResponder];
    [_txtUserName resignFirstResponder];
    
    NSString *userName = [_txtUserName text];
    NSString *passWord = [_txtPassword text];
    //
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setValue:userName forKey:@"username"];
    [dictParams setValue:passWord forKey:@"password"];
    
    [[NKApiClient shareInstace] getPath:@"login.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject = [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON OBJECT = %@", jsonObject);
        if (jsonObject) {
            [self loginSuccess];
            NSLog(@"Class = %@", [[[jsonObject objectAtIndex:0] valueForKey:kAccID] class] );
            [[UserManager sharedInstance] updateInfoWithDictionary:[jsonObject objectAtIndex:0]];
        }else
        {
            [self loginFailed];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error = %@", error);
        
    }];
    
}

-(void) loginSuccess
{
    BOOL autoRemember = [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_remember_preference"];
    if(autoRemember)
    {
        [[NSUserDefaults standardUserDefaults] setValue:self.txtUserName.text forKey:@"username_preference"];
        [[NSUserDefaults standardUserDefaults] setValue:self.txtPassword.text forKey:@"password_preference"];
    }
    
    AppDelegate *appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.overlayView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        appDelegate.overlayView.hidden = YES;
        DoorsTransition *_transition = [[DoorsTransition alloc] init];
        [[HMGLTransitionManager sharedTransitionManager] setTransition:_transition];
        [[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:self];
    }];
}
-(void) loginFailed
{
    NSLog(@"Login failed");
}

-(void) signupAccountSuccessful: (NSNotification *) notification
{
    self.txtUserName.text = [[UserManager sharedInstance] username];
    self.txtPassword.text = [[UserManager sharedInstance] password];
}



@end
