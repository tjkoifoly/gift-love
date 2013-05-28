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
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "JSONKit.h"
#import "UserManager.h"
#import "FunctionObject.h"
#import "EGOImageLoader.h"
#import "TSMessage.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

@interface ChatViewController ()
{
    NSMutableArray *bubbleData;
    UIImage *avataMe;
    UIImage *avataFriend;
    NSTimer *timerSchedule;
    NSMutableDictionary *dictAvatar;
    NSString *lastDate;
    BOOL firstLoad;
}

@end

@implementation ChatViewController

@synthesize friendChatting = _friendChatting;
@synthesize inputToolbar = _inputToolbar;
@synthesize mode = _mode;
@synthesize groupMembers = _groupMembers;
@synthesize group = _group;
@synthesize tokenFieldView;

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
    firstLoad = NO;
    
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
    }else if (_group)
    {
        UITextField *labelTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        labelTitle.tag = 1234;
        labelTitle.placeholder = @"Group name";
        [labelTitle setFont:[UIFont boldSystemFontOfSize:18]];
        labelTitle.minimumFontSize = 10.0f;
        labelTitle.textColor= [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = [_group valueForKey:@"gmName"];
        self.navigationItem.titleView = labelTitle;
        
       
    }
    
    bubbleData = [[NSMutableArray alloc] init];
    _bubbleTable.bubbleDataSource = self;
    _bubbleTable.backgroundColor = [UIColor clearColor];

    _bubbleTable.snapInterval = 120;
    _bubbleTable.showAvatars = YES;
    
    [_bubbleTable reloadData];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.delegate = self;
    tapRecognizer.numberOfTapsRequired = 1;
    [_bubbleTable addGestureRecognizer:tapRecognizer];
    
    //Add token field
    if (_mode == ChatModeGroup) {
        tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.bubbleTable.bounds];
        [tokenFieldView setSourceArray:[[FriendsManager sharedManager] friendsList]];
        tokenFieldView.backgroundColor = [UIColor clearColor];
        tokenFieldView.tokenField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        tokenFieldView.tokenField.leftView.backgroundColor = [UIColor clearColor];

        tokenFieldView.tokenField.textColor = [UIColor blackColor];
        
        [self.view addSubview:tokenFieldView];
        
        if (!_groupMembers) {
            _groupMembers = [[NSMutableArray alloc] init];
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
        [_bubbleTable setScrollEnabled:NO];
        
        lastDate = @"";
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
    
    //Listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePersonFromGroup:) name:kNotificationRemovePersonFromGroup object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPersonToGroup:) name:kNotificationAddPersonToGroup object:nil];

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[UserManager sharedInstance] imgAvata]]];
        avataMe = [UIImage imageWithData:data];
    });
   
    switch (_mode) {
        case ChatModeSigle:
        {
            dispatch_async(queue, ^{
                if ([_friendChatting.fAvatarLink length]) {
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_friendChatting.fAvatarLink]];
                    avataFriend = [UIImage imageWithData:data];
                }
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [self getMessageFromFriend:_friendChatting completion:^(BOOL success, NSError *error) {
                    [_bubbleTable reloadData];
                    
                    if ([bubbleData count] > 0) {
                        [self scrollToBottom:NO];
                    }
                    [HUD hide:YES];
                }];
            });
        }
            break;
        case ChatModeGroup:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [self getMessageFromGroup:[_group valueForKey:@"gmID"] withLastDate:lastDate completion:^(BOOL success, NSError *error) {
                    [_bubbleTable reloadData];
                    [HUD hide:YES];
                }];
            });
    
#pragma mark - List Friend -----------------------
            
            [self listFriendsInGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error, id result) {
                [_groupMembers removeAllObjects];
                if (!dictAvatar) {
                    dictAvatar = [[NSMutableDictionary alloc] init];
                }
                for(NSDictionary *dictFriend in result)
                {
                    Friend *nF = [[Friend alloc] initWithDictionary:dictFriend];
                    [_groupMembers addObject:nF];
                    TIToken *token = [tokenFieldView.tokenField addTokenWithTitle:nF.userName representedObject:nF];
                    
                    if (token) {
                        if ([nF.userName isEqualToString:[[UserManager sharedInstance] username]]) {
                            [token setTintColor:[UIColor redColor]];
                            UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTokenDetected:)];
                            tr.numberOfTapsRequired = 2;
                            tr.delegate = self;
                            [token addGestureRecognizer:tr];
                        }
                        [tokenFieldView.tokenField autoAddToken:token];
                    }
                    
                    //LOAD AVATAR
                    dispatch_async(queue, ^{
                        if ([nF.fAvatarLink length]) {
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nF.fAvatarLink]];
                            UIImage *imgFA = [UIImage imageWithData:data];
                            [dictAvatar setValue:imgFA forKey:nF.fID];
                        }
                    });
                                      
                }
                 [tokenFieldView.tokenField resignFirstResponder];
                [tokenFieldView.tokenField didEndEditing];
                
                if (_newGroup) {
                    UIView *v = [self.navigationController.view viewWithTag:1234];
                    [v becomeFirstResponder];
                }
                
                //[self scrollToBottom];
                NSLog(@"MEMBER = %@", _groupMembers);
                
            }];

        }
            break;
            
        default:
            break;
    }
    
    if (!timerSchedule) {
        dispatch_async(dispatch_get_main_queue(), ^{
            timerSchedule = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadMessages) userInfo:nil repeats:YES];
        });
    }
}

-(void) viewWillAppear:(BOOL)animated{
    
    [tokenFieldView resignFirstResponder];
    [super viewWillAppear:animated];
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) scrollToBottom :(BOOL) animated
{
    if (_mode == ChatModeGroup) {
        CGFloat height = tokenFieldView.contentView.bounds.size.height - tokenFieldView.bounds.size.height + tokenFieldView.tokenField.bounds.size.height;
        
        CGPoint bottomOffset = CGPointMake(0, height) ;
        [tokenFieldView setContentOffset:bottomOffset animated:animated];
        return;
    }
    
    CGFloat height = self.bubbleTable.contentSize.height - self.bubbleTable.bounds.size.height;
    if (height > 0) {
        [self.bubbleTable setContentOffset:CGPointMake(0, height) animated:animated];
    }
}

-(void) scrollToLastIndexPath
{
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)] - 1) inSection:(_bubbleTable.numberOfSections - 1)];
    [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
    [timerSchedule invalidate];
    timerSchedule = nil;
}


- (void)viewDidUnload {
    [self setTbTextField:nil];
    [self setBubbleTable:nil];
    [self setTfMessage:nil];
    [self setFriendChatting:nil];
    [self setInputToolbar:nil];
    [self setGroupMembers:nil];
    [self setGroup:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationAddPersonToGroup object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRemovePersonFromGroup object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [super viewDidUnload];
}

#pragma mark - Token field
- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
    
    if (tokenField.editing) {
        dispatch_async(dispatch_get_main_queue(),  ^{
            NSString *notificationTitle = NSLocalizedString(@"To leave group?", nil);
            NSString *notificationDescription = NSLocalizedString(@"Open token field and double tap on your username to leave this group !", nil) ;
            
            CGFloat duration = 4;
            
            [TSMessage showNotificationInViewController:self
                                              withTitle:notificationTitle
                                            withMessage:notificationDescription
                                               withType:TSMessageNotificationTypeMessage
                                           withDuration:duration];
        });
    }
    
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
	/*
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
     */
    
    [tokenFieldView.tokenField resignFirstResponder];
    
    ModalPanelPickerView *modalPanel = [[ModalPanelPickerView alloc] initWithFrame:self.view.bounds title:@"Choose Friend" mode:ModalPickerFriends subArray:_groupMembers] ;
    NSLog(@"------------> %@", _groupMembers);
    [modalPanel.actionButton setTitle:@"Add" forState:UIControlStateNormal];
    
    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
        UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
    };
    
    ///////////////////////////////////////////
    //   Panel is a reference to the modalPanel
    modalPanel.delegate =self;
    
    [self.view addSubview:modalPanel];
	
	///////////////////////////////////
	// Show the panel from the center of the button that was pressed
	[modalPanel showFromPoint:self.view.center];

}

-(void) tapTokenDetected: (UITapGestureRecognizer *) reg
{
    [timerSchedule invalidate];
    [self removeFriend:[[UserManager sharedInstance] accID] fromGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error) {
        TIToken *tk = (TIToken *)[reg view];
        [tokenFieldView.tokenField removeToken:tk];
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(leaveGroup:)]) {
            [self.delegate leaveGroup:self.group];
        }
    }];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self contentDidChange:_bubbleTable];
}

- (void)contentDidChange:(UITableView *)tbView {
	
	CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
    //CGFloat oldHeight = tbView.frame.size.height;
	CGFloat newHeight = tbView.contentSize.height;
	
	CGRect newTextFrame = tbView.frame;
	newTextFrame.size = tbView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
    
	[tokenFieldView.contentView setFrame:newFrame];
	[tbView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
    
}

-(void) updateContentFrame
{
    CGRect tableFrame = _bubbleTable.frame;
    
    tableFrame.size.height = _bubbleTable.contentSize.height;
    [_bubbleTable setFrame:tableFrame];
    tableFrame.origin.y = tokenFieldView.tokenField.frame.size.height;
    tokenFieldView.contentView.frame = tableFrame;
    
    [tokenFieldView updateContentSize];
}

- (void)resizeViews {
    int tabBarOffset = self.inputToolbar == nil ?  0 : self.inputToolbar.frame.size.height;
	[tokenFieldView setFrame:((CGRect){tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - keyboardHeight}})];
	[_bubbleTable setFrame:tokenFieldView.contentView.bounds];
}

-(void) tokenField:(TITokenField *)tokenField didAddTokenBySearch:(id)token{
    
    NSLog(@"ID = %@", token);
    if ([token isKindOfClass:[Friend class]]) {
        
        [self addFriend:((Friend *)token).fID toGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error) {
            
        }];
    }
    
}

#pragma mark - Panel Delegate
- (void)didSelectActionButton:(UAModalPanel *)modalPanel {
	UADebugLog(@"didSelectActionButton called with modalPanel: %@", modalPanel);
    [modalPanel hideWithOnComplete:^(BOOL finished) {
               
    }];
}



#pragma mark - Emoticon


//------------------------------------------------------



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
    [self->_emojiPopover showFromPoint:CGPointMake(sender.center.x, sender.bounds.size.height) inView:self.navigationController.view withTitle:@"Click on a character to send it"];
}

#pragma mark - SYEmojiPopoverDelegate methods

-(void)emojiPopover:(SYEmojiPopover *)emojiPopover didClickedOnCharacter:(NSString *)character
{
    
    switch (_mode) {
        case ChatModeGroup:
        {
            [self postMessage:character withType:MessageEmoticon toGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error, id result) {
                
            }];
        }
            break;
        case ChatModeSigle:
        {
            _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
            
            UIFont *customFont = [UIFont fontWithName:@"AppleColorEmoji" size:50.0f];
            NSBubbleData *sayBubble = [NSBubbleData dataWithText:character date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine font:customFont];
            
            NSLog(@"FONT = %@", customFont);
            
            sayBubble.avatar = avataMe;
            [bubbleData addObject:sayBubble];
            [_bubbleTable reloadData];
            
            [self postMessage:character withType:MessageEmoticon toFriend:_friendChatting completion:^(BOOL success, NSError *error, id result) {
                //
            }];
        }
            break;
            
        default:
            break;
    }
   
    
    [self scrollToBottom:YES];

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
    
    if ([self.navigationItem.titleView isFirstResponder]) {
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
             
            if (_mode == ChatModeGroup) {
                CGRect frameToken = tokenFieldView.frame;
                frameToken.size.height -= kbSize.height;
                tokenFieldView.frame = frameToken;

            }else
            {
                CGRect frame = _bubbleTable.frame;
                frame.size.height -= kbSize.height;
                _bubbleTable.frame = frame;
                
            }
            [self scrollToBottom:NO];
            
        }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardHeight = 0;
    
    if ([tokenFieldView.tokenField isFirstResponder]) {
        return;
    }
    if ([self.navigationItem.titleView isFirstResponder]) {
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
            
            if (_mode == ChatModeGroup) {
                CGRect frameToken = tokenFieldView.frame;
                frameToken.size.height += kbSize.height;
                tokenFieldView.frame = frameToken;
            }else
            {
                CGRect frame = _bubbleTable.frame;
                frame.size.height += kbSize.height;
                _bubbleTable.frame = frame;
            }
            
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
    sayBubble.avatar = avataMe;
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
    
	NSLog(@"Photo = %@", image);
    switch (_mode) {
        case ChatModeSigle:
        {
            _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
            
            NSBubbleData *sayBubble = [NSBubbleData dataWithImage:image date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
            sayBubble.avatar = avataMe;
            
            [bubbleData addObject:sayBubble];
            [_bubbleTable reloadData];
            
            [self scrollToBottom:YES];
            
            [self postMessage:@"" withType:MessageImage toFriend:_friendChatting completion:^(BOOL success, NSError *error, id result) {
                if (result) {
                    NSData *dataImage = UIImagePNGRepresentation(image);
                    [[FunctionObject sharedInstance] sendPhoto:dataImage WithProgress:^(CGFloat progress) {
                        NSLog(@"Uploading ..... %f %%", progress);
                    } completion:^(BOOL success, NSError *error, NSString *urlUpload) {
                        [[FunctionObject sharedInstance] updatePhotoMessage:result withLink:urlUpload andType:@"0" completion:^(BOOL success, NSError *error) {
                            
                            NSString *notificationTitle = @"Sent successfully";
                            NSString *notificationDescription = [NSString stringWithFormat: @"You has just sent a phto to %@", _friendChatting.userName];
                            [TSMessage showNotificationInViewController:self
                                                              withTitle:notificationTitle
                                                            withMessage:notificationDescription
                                                               withType:TSMessageNotificationTypeSuccess
                                                           withDuration:2];
                            
                        }];
                    }];
                }
            }];

        }
            break;
        case ChatModeGroup:
        {
            [self postMessage:@"" withType:MessageImage toGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error, id result) {
                if (result) {
                    NSData *dataImage = UIImagePNGRepresentation(image);
                    [[FunctionObject sharedInstance] sendPhoto:dataImage WithProgress:^(CGFloat progress) {
                        NSLog(@"Uploading ..... %f %%", progress);
                    } completion:^(BOOL success, NSError *error, NSString *urlUpload) {
                        [[FunctionObject sharedInstance] updatePhotoMessage:result withLink:urlUpload andType:@"1" completion:^(BOOL success, NSError *error) {
                            
                            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_bubbleTable numberOfRowsInSection:(_bubbleTable.numberOfSections - 1)]-1) inSection:(_bubbleTable.numberOfSections - 1)];
                            [_bubbleTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        }];
                    }];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
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
    
    switch (_mode) {
        case ChatModeSigle:
        {
            _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0] ;
            lastDate = [[FunctionObject sharedInstance] stringFromDateTime:date];
            NSBubbleData *sayBubble = [NSBubbleData dataWithText:inputText date:date type:BubbleTypeMine];
            sayBubble.avatar = avataMe;
            [bubbleData addObject:sayBubble];
            [_bubbleTable reloadData];
            [self scrollToBottom:YES];
            [self postMessage:inputText withType:MessageText toFriend:_friendChatting completion:^(BOOL success, NSError *error, id result) {
                NSLog(@"POST message: %@", inputText);
            }];
        }
            break;
        case ChatModeGroup:
        {
            [self postMessage:inputText withType:MessageText toGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error, id result) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    
    
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
        
        [self changeGroup:[_group valueForKey:@"gmID"] withName:tfTitle.text completion:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"OK");
            }
        }];
    }
}

#pragma mark - TokenField
-(NSString *) tokenField:(TITokenField *)tokenField displayStringForRepresentedObject:(id)object{
    if ([object isKindOfClass:[Friend class]]){
		return ((Friend *)object).userName;
	}
	
	return [NSString stringWithFormat:@"%@", object];
}

- (NSString *)tokenField:(TITokenField *)tokenField searchResultStringForRepresentedObject:(id)object
{
    if ([object isKindOfClass:[Friend class]]){
		return ((Friend *)object).userName;
	}
	
	return [NSString stringWithFormat:@"%@", object];
}

-(void) addPersonToGroup: (NSNotification *) notification
{
    Friend *nF = notification.object;
    [_groupMembers addObject:nF];
    TIToken *token = [tokenFieldView.tokenField addTokenWithTitle:nF.userName representedObject:nF];
    if (token) {
        __weak typeof(self) weakSelf = self;
        [self addFriend:nF.fID toGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error) {
            [weakSelf.tokenFieldView.tokenField autoAddToken:token];
            [weakSelf.tokenFieldView.tokenField resignFirstResponder];
            [weakSelf.tokenFieldView.tokenField didEndEditing];
        }];
    }
}
-(void) removePersonFromGroup: (NSNotification *) notification
{
    Friend *nF = notification.object;
    [_groupMembers removeObject:nF];
    
    __weak typeof(self) weakSelf = self;
    [self removeFriend:nF.fID fromGroup:[_group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error) {
        [weakSelf.tokenFieldView.tokenField removeTokenWithTitle:nF.userName];
        [weakSelf.tokenFieldView.tokenField resignFirstResponder];
        [weakSelf.tokenFieldView.tokenField didEndEditing];
    }];
    
}

#pragma mark  - Network -------------------------------------------------
-(void) getMessageFromFriend: (Friend *)cF completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,@"senderID",
                                cF.fID, @"recieverID", nil];
    [[NKApiClient shareInstace] postPath:@"get_message.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON Result = %@", jsonObject);
        if (bubbleData) {
            [bubbleData removeAllObjects];
        }
        for(NSDictionary *dictMsg in jsonObject)
        {
            NSBubbleType type;
            if ([[dictMsg valueForKey:@"mbSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                type = BubbleTypeMine;
            }else{
                type = BubbleTypeSomeoneElse;
            }
            
            NSBubbleData *data = nil;
            
            if ([[dictMsg valueForKey:@"msType"] intValue] == MessageEmoticon) {
                UIFont *customFont = [UIFont fontWithName:@"AppleColorEmoji" size:50.0f];
                
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"msMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type font:customFont];
            }else if ([[dictMsg valueForKey:@"msType"] intValue] == MessageText)
            {
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"msMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type];
            }else if ([[dictMsg valueForKey:@"msType"] intValue] == MessageImage)
            {
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictMsg valueForKey:@"msMessage" ]]]];
                
                data = [NSBubbleData dataWithImage:image date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type];

            }

                
            if ([[dictMsg valueForKey:@"mbSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                data.avatar = avataMe;
            }else{
                data.avatar = avataFriend;
            }
                        
            [bubbleData addObject:data];
        }
        completionBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];

}

-(void) getNewMessagesFromFriend: (Friend *)cF completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,@"senderID",
                                cF.fID, @"recieverID", nil];
    [[NKApiClient shareInstace] postPath:@"get_new_messages.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON Result = %@", jsonObject);
        
        for(NSDictionary *dictMsg in jsonObject)
        {
            NSBubbleType type;
            if ([[dictMsg valueForKey:@"mbSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                type = BubbleTypeMine;
            }else{
                type = BubbleTypeSomeoneElse;
            }
            
            NSBubbleData *data = nil;
            
            if ([[dictMsg valueForKey:@"msType"] intValue] == MessageEmoticon) {
                UIFont *customFont = [UIFont fontWithName:@"AppleColorEmoji" size:50.0f];
                
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"msMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type font:customFont];
            }else if ([[dictMsg valueForKey:@"msType"] intValue] == MessageText)
            {
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"msMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type];
            }else if ([[dictMsg valueForKey:@"msType"] intValue] == MessageImage)
            {
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictMsg valueForKey:@"msMessage" ]]]];
                
                data = [NSBubbleData dataWithImage:image date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"msDateSent"]] type:type];
                
            }
            
            if ([[dictMsg valueForKey:@"mbSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                data.avatar = avataMe;
            }else{
                data.avatar = avataFriend;
            }
            
            [bubbleData addObject:data];
            [_bubbleTable reloadData];
            [self scrollToBottom:YES];
        }
        completionBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
    
}

-(void) getMessageFromGroup: (NSString *)groupID withLastDate:(NSString *)strDate completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"groupID",
                                strDate, @"limit",
                                 nil];
    [[NKApiClient shareInstace] postPath:@"get_messages_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON Result Message Group = %@", jsonObject);
        
        for(NSDictionary *dictMsg in jsonObject)
        {
            NSBubbleType type;
            if ([[dictMsg valueForKey:@"mgSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                type = BubbleTypeMine;
            }else{
                type = BubbleTypeSomeoneElse;
            }
            
            NSBubbleData *data = nil;
            
            if ([[dictMsg valueForKey:@"mgType"] intValue] == MessageEmoticon) {
                UIFont *customFont = [UIFont fontWithName:@"AppleColorEmoji" size:50.0f];
                
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"mgMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"mgDateSent"]] type:type font:customFont];
            }else if ([[dictMsg valueForKey:@"mgType"] intValue] == MessageText)
            {
                data = [[NSBubbleData alloc] initWithText:[dictMsg valueForKey:@"mgMessage" ] date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"mgDateSent"]] type:type];
            }else if ([[dictMsg valueForKey:@"mgType"] intValue] == MessageImage)
            {
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictMsg valueForKey:@"mgMessage" ]]]];
                
                data = [NSBubbleData dataWithImage:image date:[[FunctionObject sharedInstance] dateFromStringDateTime:[dictMsg valueForKey:@"mgDateSent"]] type:type];
                
            }
            
            if ([[dictMsg valueForKey:@"mgSenderID"] isEqualToString: [[UserManager sharedInstance] accID]]) {
                data.avatar = avataMe;
            }else{
                data.avatar = [dictAvatar valueForKey:[dictMsg valueForKey:@"mgSenderID"]];
            }
            
            [bubbleData addObject:data];
            [_bubbleTable reloadData];
        }
        
        if([jsonObject count] > 0)
        {
            NSDictionary *mDict = [jsonObject lastObject];
            lastDate = [mDict valueForKey:@"mgDateSent"];
            
            [_bubbleTable reloadData];
            [self updateContentFrame];
            
            [self scrollToBottom:firstLoad];
            firstLoad = YES;
            
        }
//        NSLog(@"LAST Content size = %@", NSStringFromCGSize(_bubbleTable.contentSize) );
//        NSLog(@"LAST Frame = %@", NSStringFromCGRect(_bubbleTable.frame) );
        
        
        completionBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
    
}

-(void) reloadMessages
{
    switch (_mode) {
        case ChatModeGroup:
        {
            [self getMessageFromGroup:[_group valueForKey:@"gmID"] withLastDate:lastDate completion:^(BOOL success, NSError *error) {
            }];
        }
            break;
        case ChatModeSigle:
        {
            [self getNewMessagesFromFriend:_friendChatting completion:^(BOOL success, NSError *error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    
}

-(void) postMessage:(NSString *)message withType:(MessageType)msType toFriend: (Friend *)cF completion:(CompletionBlockWithResult)completionBlock
{
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,@"senderID",
                                cF.fID, @"recieverID",
                                message, @"message",
                                [NSString stringWithFormat:@"%i", msType],@"msType",nil];
    [[NKApiClient shareInstace] postPath:@"post_message.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result = %@", jsonObject);
        
        if (msType == MessageImage) {
            id result = nil;
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                result = [jsonObject objectAtIndex:0];
            }
            completionBlock(YES, nil, result);
        }else{
            completionBlock(YES, nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
    
}

-(void) postMessage:(NSString *)message withType:(MessageType)msType toGroup: (NSString *)groupID completion:(CompletionBlockWithResult)completionBlock
{
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,@"senderID",
                                groupID, @"groupID",
                                message, @"mgMessage",
                                [NSString stringWithFormat:@"%i", msType],@"mgType",nil];
    [[NKApiClient shareInstace] postPath:@"post_message_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result Post message = %@", jsonObject);
        
        if (msType == MessageImage) {
            id result = nil;
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                result = [jsonObject objectAtIndex:0];
            }
            completionBlock(YES, nil, result);
        }else{
            completionBlock(YES, nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, error, nil);
    }];
}

-(void) listFriendsInGroup: (NSString*)groupID completion:(void (^)(BOOL success, NSError *error , id result))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:groupID,@"gmID", nil];
    [[NKApiClient shareInstace] postPath:@"get_friends_in_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Friends in Group = %@", jsonObject);
        
        completionBlock (YES, nil, jsonObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}

-(void) changeGroup: (NSString*)groupID withName: (NSString *) gName completion:(void (^)(BOOL success, NSError *error))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"groupID",
                                gName,@"groupName",nil];
    [[NKApiClient shareInstace] postPath:@"update_group_name.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON GROUP Name = %@", jsonObject);
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) addFriend: (NSString*)friendID toGroup: (NSString *) groupID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"gmID",
                                friendID,@"friendID",
                                @"add", @"usage",nil];
    [[NKApiClient shareInstace] postPath:@"add_friend_to_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Add friend to group = %@", jsonObject);
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) removeFriend: (NSString*)userID fromGroup: (NSString *) groupID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"groupID",
                                userID,@"userID",
                                nil];
    [[NKApiClient shareInstace] postPath:@"leave_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Remove friend from group = %@", jsonObject);
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}



@end
