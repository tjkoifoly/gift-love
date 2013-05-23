//
//  FriendsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"
#import "FriendsManager.h"
#import "TDBadgedCell.h"
#import "DDActionHeaderView.h"
#import "HHPanningTableViewCell.h"
#import "DrawerViewMenu.h"
#import "AddFriendViewController.h"
#import "ModalPanelPickerView.h"
#import "MBProgressHUD.h"
#import "FriendRequestCell.h"

typedef enum {
    FriendModeList,
    RequestModeList,
} FriendMode;

@interface FriendsViewController : GHRootViewController <UITableViewDataSource, UITableViewDelegate, HHPanningTableViewCellDelegate, DrawerMenuDelegate, UIActionSheetDelegate, ModalPanelDelegate , FriendRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DDActionHeaderView *actionHeaderView;
@property (nonatomic) FriendMode mode;
@property (strong, nonatomic) NSMutableArray *listRequest;
-(void) itemAction: (id)sender;

-(void) reloadFriend;

@end
