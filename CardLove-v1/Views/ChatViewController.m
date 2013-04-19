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
#import "UITableView+reloadDataWithAnimation.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

@interface ChatViewController ()
{
    NSMutableArray *bubbleData;
}

@end

@implementation ChatViewController

@synthesize friendChatting = _friendChatting;
@synthesize inputToolbar = _inputToolbar;

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
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pickerImage:)];
    self.navigationItem.rightBarButtonItem = btnCamera;
    
    keyboardIsVisible = NO;
    
    /* Calculate screen size */
    CGRect screenFrame = self.view.frame;
    /* Create toolbar */
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight, screenFrame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    _inputToolbar.delegate = self;
    _inputToolbar.textView.placeholder = @"Type a message here";
    [self.inputToolbar.textView setMaximumNumberOfLines:13]; 
    
    //UI
    if (_friendChatting) {
        self.navigationItem.title = _friendChatting.displayName;
    }
    
    bubbleData = [[NSMutableArray alloc] init];
    _bubbleTable.bubbleDataSource = self;

    _bubbleTable.snapInterval = 120;
    _bubbleTable.showAvatars = YES;
    
    _bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    [_bubbleTable reloadData];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.delegate = self;
    tapRecognizer.numberOfTapsRequired = 1;
    [_bubbleTable addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) pickerImage: (id) sender
{
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""), NSLocalizedString(@"take_photo_from_library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setTbTextField:nil];
    [self setBubbleTable:nil];
    [self setTfMessage:nil];
    [self setFriendChatting:nil];
    [self setInputToolbar:nil];
    [super viewDidUnload];
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
        
        CGRect rf = _inputToolbar.frame;
        rf.origin.y -= kbSize.height;
        _inputToolbar.frame = rf;

        
    } completion:^(BOOL finished) {
        
        CGRect frame = _bubbleTable.frame;
        frame.size.height -= kbSize.height;
        _bubbleTable.frame = frame;
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
        [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    keyboardIsVisible = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _tbTextField.frame;
        frame.origin.y += kbSize.height;
        _tbTextField.frame = frame;
        
        CGRect rf = _inputToolbar.frame;
        rf.origin.y += kbSize.height;
        _inputToolbar.frame = rf;
        
    } completion:^(BOOL finished) {
       
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGRect frame = _bubbleTable.frame;
        frame.size.height += kbSize.height;
        _bubbleTable.frame = frame;
        
        [UIView commitAnimations];
        
    }];
    keyboardIsVisible = NO;
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	//imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleType type = arc4random() % 2;
    NSBubbleData *sayBubble = [NSBubbleData dataWithImage:image date:[NSDate dateWithTimeIntervalSinceNow:0] type:type];
    [bubbleData addObject:sayBubble];
    
    [_bubbleTable reloadData];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
    [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

	NSLog(@"Photo = %@", image);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)inputButtonPressed:(NSString *)inputText
{
    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
    if ([inputText isEqualToString:@""]) {
        return;
    }
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    NSBubbleType type = arc4random() % 2;
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:inputText date:[NSDate dateWithTimeIntervalSinceNow:0] type:type];
    [bubbleData addObject:sayBubble];
    [_bubbleTable reloadData];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)]-1) inSection:(_bubbleTable.numberOfSections - 1)];
    [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - Gesture Delegate
-(void) tapDetected: (UITapGestureRecognizer *) tapRecognizer
{
    [self.inputToolbar.textView resignFirstResponder];
}


@end
