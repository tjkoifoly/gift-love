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

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *tbTextField;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (weak, nonatomic) IBOutlet UITextField *tfMessage;

@end
