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
@synthesize mode = _mode;
@synthesize groupMembers = _groupMembers;

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
    
    UIButton *btnEmoj = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmoj setBackgroundImage:[UIImage imageNamed:@"emo.png"] forState:UIControlStateNormal];
    [btnEmoj setFrame:CGRectMake(0, 0, 34, 34)];
    [btnEmoj addTarget:self action:@selector(pickerEmoj:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnCamera,[[UIBarButtonItem alloc] initWithCustomView:btnEmoj], nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"style_8.png"]];
    inputToolbarIsVisible = NO;
    
    //UI
    if (_friendChatting) {
        UITextField *labelTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:18]];
        labelTitle.textColor= [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = _friendChatting.displayName;
        labelTitle.enabled = NO;
        self.navigationItem.titleView = labelTitle;
    }else if (_groupMembers)
    {
        UITextField *labelTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:18]];
        labelTitle.textColor= [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = _friendChatting.displayName;
        self.navigationItem.titleView = labelTitle;
    }
    
    bubbleData = [[NSMutableArray alloc] init];
    _bubbleTable.bubbleDataSource = self;
    _bubbleTable.backgroundColor = [UIColor clearColor];

    _bubbleTable.snapInterval = 120;
    _bubbleTable.showAvatars = YES;
    
    _bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    [_bubbleTable reloadData];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.delegate = self;
    tapRecognizer.numberOfTapsRequired = 1;
    [_bubbleTable addGestureRecognizer:tapRecognizer];
    
    //Add token field
    if (_mode == ChatModeGroup) {
        tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.bubbleTable.bounds];
        [tokenFieldView setSourceArray:[Names listOfNames]];
        tokenFieldView.backgroundColor = [UIColor clearColor];
        tokenFieldView.tokenField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        tokenFieldView.tokenField.leftView.backgroundColor = [UIColor clearColor];

        tokenFieldView.tokenField.textColor = [UIColor blackColor];
        
        [self.view addSubview:tokenFieldView];
        
       for(Friend *f in _groupMembers)
       {
           TIToken * token = [tokenFieldView.tokenField addTokenWithTitle:f.displayName];
           [tokenFieldView.tokenField addToken:token];
       }
        
        [tokenFieldView.tokenField setDelegate:self];

        [tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:(UIControlEvents)TITokenFieldControlEventFrameDidChange];
        [tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
        [tokenFieldView.tokenField setRightView:addButton];
        [tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
        [_bubbleTable setAutoresizingMask:UIViewAutoresizingNone];
        [tokenFieldView.contentView addSubview:_bubbleTable];
    }
    
    /* Calculate screen size */
    CGRect screenFrame = self.view.frame;
    /* Create toolbar */
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight, screenFrame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    _inputToolbar.delegate = self;
    _inputToolbar.textView.placeholder = @"Type a message here";
    [self.inputToolbar.textView setMaximumNumberOfLines:13];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidUnload {
    [self setTbTextField:nil];
    [self setBubbleTable:nil];
    [self setTfMessage:nil];
    [self setFriendChatting:nil];
    [self setInputToolbar:nil];
    [self setGroupMembers:nil];
    [super viewDidUnload];
}

#pragma mark - Token field
- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
   
    if (inputToolbarIsVisible) {
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _tbTextField.frame;
            frame.origin.y += keyboardHeight;
            _tbTextField.frame = frame;
            
            CGRect rf = _inputToolbar.frame;
            rf.origin.y += keyboardHeight;
            _inputToolbar.frame = rf;
            
            CGRect frameBubble = _bubbleTable.frame;
            frameBubble.size.height += keyboardHeight;
            _bubbleTable.frame = frameBubble;
            
        } completion:^(BOOL finished) {
            inputToolbarIsVisible = NO;
        }];
    }
}

- (void)showContactsPicker:(id)sender {
	
	// Show some kind of contacts picker in here.
	// For now, here's how to add and customize tokens.
	
	NSArray * names = [Names listOfNames];
    for(TIToken *tk in tokenFieldView.tokenField.tokens)
    {
        if ([tk isSelected]) {
            [tokenFieldView.tokenField removeToken:tk];
        }
    }
	
	TIToken * token = [tokenFieldView.tokenField addTokenWithTitle:[names objectAtIndex:(arc4random() % names.count)]];
    
    UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTokenDetected:)];
    tr.numberOfTapsRequired = 2;
    tr.delegate = self;
    [token addGestureRecognizer:tr];
    
	[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	[tokenFieldView.tokenField layoutTokensAnimated:YES];
	
	NSUInteger tokenCount = tokenFieldView.tokenField.tokens.count;
	[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
}

-(void) tapTokenDetected: (UITapGestureRecognizer *) reg
{
    TIToken *tk = (TIToken *)[reg view];
    [tokenFieldView.tokenField removeToken:tk];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self contentDidChange:_bubbleTable];
}

- (void)contentDidChange:(UITableView *)textView {
	
	CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
    
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
}

- (void)resizeViews {
    int tabBarOffset = self.inputToolbar == nil ?  0 : self.inputToolbar.frame.size.height;
	[tokenFieldView setFrame:((CGRect){tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - keyboardHeight}})];
	[_bubbleTable setFrame:tokenFieldView.contentView.bounds];
}


//------------------------------------------------------



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

-(void) pickerEmoj: (UIButton *) sender
{
    if(!self->_emojiPopover)
        self->_emojiPopover = [[SYEmojiPopover alloc] init];
    
    [self->_emojiPopover setDelegate:self];
    [self->_emojiPopover showFromPoint:CGPointMake(sender.center.x, sender.bounds.size.height) inView:self.navigationController.view withTitle:@"Click on a character to see it in big"];
}

#pragma mark - SYEmojiPopoverDelegate methods

-(void)emojiPopover:(SYEmojiPopover *)emojiPopover didClickedOnCharacter:(NSString *)character
{
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    NSBubbleType type = arc4random() % 2;
    UIFont *customFont = [UIFont fontWithName:@"AppleColorEmoji" size:50.0f];
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:character date:[NSDate dateWithTimeIntervalSinceNow:0] type:type font:customFont];
    [bubbleData addObject:sayBubble];
    [_bubbleTable reloadData];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)]-1) inSection:(_bubbleTable.numberOfSections - 1)];
    [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

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
    keyboardHeight = kbSize.height;
    
    if ([tokenFieldView.tokenField isFirstResponder]) {
        
        return;
    }
    
    if (![_tfMessage isFirstResponder]) {
        return;
    }
    
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _tbTextField.frame;
            frame.origin.y -= kbSize.height;
            _tbTextField.frame = frame;
            
            CGRect rf = _inputToolbar.frame;
            rf.origin.y -= kbSize.height;
            _inputToolbar.frame = rf;
            
             inputToolbarIsVisible = YES;
            
        } completion:^(BOOL finished) {
            
            CGRect frame = _bubbleTable.frame;
            frame.size.height -= kbSize.height;
            _bubbleTable.frame = frame;
            
//            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
//            [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            CGFloat height = self.bubbleTable.contentSize.height - self.bubbleTable.bounds.size.height;
            if (height > 0) {
                [self.bubbleTable setContentOffset:CGPointMake(0, height) animated:YES];
            }
        }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardHeight = 0;
    
    if ([tokenFieldView.tokenField isFirstResponder]) {
        return;
    }
    if (![_tfMessage isFirstResponder]) {
        return;
    }
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _tbTextField.frame;
            frame.origin.y += kbSize.height;
            _tbTextField.frame = frame;
            
            CGRect rf = _inputToolbar.frame;
            rf.origin.y += kbSize.height;
            _inputToolbar.frame = rf;
            
             inputToolbarIsVisible = NO;
            
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
    
    [_bubbleTable beginUpdates];
    [_bubbleTable reloadData];
    [_bubbleTable endUpdates];
    
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
    [tokenFieldView.tokenField resignFirstResponder];
    
    if ([self.navigationItem.titleView isFirstResponder]) {
        UITextField *tfTitle = (UITextField *)self.navigationItem.titleView;
        [tfTitle resignFirstResponder];
        NSLog(@"Title = %@", tfTitle.text);
    }
}




@end
