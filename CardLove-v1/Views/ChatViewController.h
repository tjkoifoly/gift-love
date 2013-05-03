//
//  ChatViewController.h
//  CardLove-v1
//
//  Created by FOLY on 3/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableView.h"
#import "Friend.h"
#import "UIInputToolbar.h"
#import "SYEmojiPopover.h"
#import "TITokenField.h"
#import "Names.h"

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIInputToolbarDelegate, UIGestureRecognizerDelegate, SYEmojiPopoverDelegate, TITokenFieldDelegate>
{
    UIInputToolbar *_inputToolbar;
    
@private
    BOOL keyboardIsVisible;
    SYEmojiPopover *_emojiPopover;
}

@property (nonatomic, strong) UIInputToolbar *inputToolbar;
@property (strong, nonatomic) Friend *friendChatting;
@property (weak, nonatomic) IBOutlet UIToolbar *tbTextField;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (weak, nonatomic) IBOutlet UITextField *tfMessage;

@end
