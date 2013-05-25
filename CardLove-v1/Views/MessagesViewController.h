//
//  MessagesViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"
#import "FriendsManager.h"
#import "TDBadgedCell.h"
#import "ModalPanelPickerView.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"

@interface MessagesViewController : GHRootViewController <UITableViewDataSource, UITableViewDelegate,  ModalPanelDelegate, ChatViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) NSMutableArray *listGroups;
@property (unsafe_unretained, nonatomic) NSMutableArray *listNewMsgs;



@end
