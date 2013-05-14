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
#import "FriendsManager.h"
#import "ModalPanelPickerView.h"

typedef enum {
    ChatModeSigle,
    ChatModeGroup
}ChatMode;

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIInputToolbarDelegate, UIGestureRecognizerDelegate, SYEmojiPopoverDelegate, TITokenFieldDelegate, UAModalPanelDelegate>
{
    UIInputToolbar *_inputToolbar;
    
    TITokenFieldView * tokenFieldView;
    CGFloat keyboardHeight;
    
@private
    BOOL inputToolbarIsVisible;
    SYEmojiPopover *_emojiPopover;
}


@property (nonatomic) ChatMode mode;
@property (strong, nonatomic) NSMutableArray *groupMembers;
@property (strong, nonatomic) id group;
@property (nonatomic, strong) UIInputToolbar *inputToolbar;
@property (strong, nonatomic) Friend *friendChatting;
@property (weak, nonatomic) IBOutlet UIToolbar *tbTextField;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (weak, nonatomic) IBOutlet UITextField *tfMessage;

@end
