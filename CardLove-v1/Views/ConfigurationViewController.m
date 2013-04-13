//
//  ConfigurationViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/12/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

@synthesize pathGift = _pathGift;
@synthesize dictGiftConfig = _dictGiftConfig;

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
    
    _txtViewMessage.layer.borderColor = [UIColor blackColor].CGColor;
    _txtViewMessage.layer.borderWidth = 1.0f;
    _txtViewMessage.layer.cornerRadius = 10.0f;
    
    _scrollContainer.contentSize = self.viewContainer.bounds.size;
    [_scrollContainer addSubview:_viewContainer];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelViewController)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.navigationItem.title = @"Configuration";
    
    //Initialize
    [self loadConfiguration];
    if (!_dictGiftConfig) {
        _dictGiftConfig = [[NSMutableDictionary alloc] init];
    }
    
    //Actions
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapPaper = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(choosePaper)];
    self.imvGiftPaper.userInteractionEnabled = YES;
    [self.imvGiftPaper addGestureRecognizer:tapPaper];
    
    UITapGestureRecognizer *tapBG = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(chooseBg)];
    self.imvGiftBackground.userInteractionEnabled = YES;
    [self.imvGiftBackground addGestureRecognizer:tapBG];
    
    UITapGestureRecognizer *tapFrame = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(chooseFrame)];
    self.imvGiftFame.userInteractionEnabled = YES;
    [self.imvGiftFame addGestureRecognizer:tapFrame];
    
    //Listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void) viewDidAppear:(BOOL)animated
{
    [self reloadView];
    [super viewDidAppear:animated];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _viewContainer.frame;
        frame.origin.y -= kbSize.height;
        _viewContainer.frame = frame;
        
        
    } completion:^(BOOL finished) {
        [_scrollContainer scrollRectToVisible:_txtViewMessage.frame animated:YES];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _viewContainer.frame;
        frame.origin.y += kbSize.height;
        _viewContainer.frame = frame;
        
    } completion:^(BOOL finished) {
        [_scrollContainer scrollRectToVisible:_txtViewMessage.frame animated:YES];
    }];
}


-(void) cancelViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAction
{
    [_dictGiftConfig setValue:_txtViewMessage.text forKey:kGiftMessage];
    NSString *filePath = [_pathGift stringByAppendingPathComponent:kConfig];
    [_dictGiftConfig writeToFile:filePath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGiftConfig object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtViewMessage:nil];
    [self setImvGiftPaper:nil];
    [self setImvGiftBackground:nil];
    [self setViewContainer:nil];
    [self setDictGiftConfig:nil];
    [self setPathGift:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setScrollContainer:nil];
    [self setImvGiftFame:nil];
    [super viewDidUnload];
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void) dismissKeyboard
{
    [_txtViewMessage resignFirstResponder];
    NSLog(@"DM");

}

-(void) choosePaper
{
    [self dismissKeyboard];
    
    BGPickerViewController *bgPikcerVC = [[BGPickerViewController alloc] initWithNibName:@"BGPickerViewController" bundle:nil];
    bgPikcerVC.type = kGiftPaper;
    bgPikcerVC.dictParent = _dictGiftConfig;
    [self.navigationController pushViewController:bgPikcerVC animated:YES];
    
    NSLog(@"Paper");
}

-(void) chooseBg
{
    [self dismissKeyboard];
    
    BGPickerViewController *bgPikcerVC = [[BGPickerViewController alloc] initWithNibName:@"BGPickerViewController" bundle:nil];
    bgPikcerVC.type = kGiftBG;
    bgPikcerVC.dictParent = _dictGiftConfig;
    [self.navigationController pushViewController:bgPikcerVC animated:YES];

    
    NSLog(@"BG");
}

-(void) chooseFrame
{
    [self dismissKeyboard];
    
    BGPickerViewController *bgPikcerVC = [[BGPickerViewController alloc] initWithNibName:@"BGPickerViewController" bundle:nil];
    bgPikcerVC.type = kGiftFrame;
    bgPikcerVC.dictParent = _dictGiftConfig;
    [self.navigationController pushViewController:bgPikcerVC animated:YES];
    
    NSLog(@"Frame");
}

-(void) loadConfiguration
{
    NSString *filePath = [_pathGift stringByAppendingPathComponent:kConfig];
    _dictGiftConfig = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}

-(void) reloadView
{
    NSString *strTemp = [_dictGiftConfig valueForKey:kGiftPaper];
    UIImage *imgTemp = [UIImage imageNamed:strTemp];
    _imvGiftPaper.image = imgTemp;
    
    strTemp = [_dictGiftConfig valueForKey:kGiftBG];
    imgTemp = [UIImage imageNamed:strTemp];
    _imvGiftBackground.image = imgTemp;
    
    strTemp = [_dictGiftConfig valueForKey:kGiftFrame];
    imgTemp = [UIImage imageNamed:strTemp];
    _imvGiftFame.image = imgTemp;
    
    strTemp = [_dictGiftConfig valueForKey:kGiftMessage];
    _txtViewMessage.text = strTemp;
    
}


@end
