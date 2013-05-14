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

@interface MessagesViewController : GHRootViewController <UITableViewDataSource, UITableViewDelegate, UAModalPanelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listGroups;

@end
