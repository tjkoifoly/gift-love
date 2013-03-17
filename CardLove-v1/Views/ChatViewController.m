//
//  ChatViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"

@interface ChatViewController ()
{
    NSMutableArray *bubbleData;
}

@end

@implementation ChatViewController

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
    self.navigationItem.title = @"Conversation";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    bubbleData = [[NSMutableArray alloc] init];
    _bubbleTable.bubbleDataSource = self;

    _bubbleTable.snapInterval = 120;
    _bubbleTable.showAvatars = YES;
    
    _bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [_bubbleTable reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _tbTextField.frame;
        frame.origin.y -= kbSize.height;
        _tbTextField.frame = frame;

        
    } completion:^(BOOL finished) {
        
        CGRect frame = _bubbleTable.frame;
        frame.size.height -= kbSize.height;
        _bubbleTable.frame = frame;
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
        [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _tbTextField.frame;
        frame.origin.y += kbSize.height;
        _tbTextField.frame = frame;
        
    } completion:^(BOOL finished) {
       
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGRect frame = _bubbleTable.frame;
        frame.size.height += kbSize.height;
        _bubbleTable.frame = frame;
        
        [UIView commitAnimations];
        

    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    if([_tfMessage.text isEqualToString:@""])
    {
        return;
    }
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:_tfMessage.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    
    [_bubbleTable reloadData];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
    [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _tfMessage.text = @"";
    //[_tfMessage resignFirstResponder];
}

#pragma mark - TextField Delegate
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
}

-(IBAction)resignKeyboard:(id)sender
{
    [_tfMessage resignFirstResponder];
}

- (void)viewDidUnload {
    [self setTbTextField:nil];
    [self setBubbleTable:nil];
    [self setTfMessage:nil];
    [super viewDidUnload];
}
@end
