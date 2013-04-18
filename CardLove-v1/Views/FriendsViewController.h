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

@interface FriendsViewController : GHRootViewController <UITableViewDataSource, UITableViewDelegate, HHPanningTableViewCellDelegate, DrawerMenuDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DDActionHeaderView *actionHeaderView;

-(void) itemAction: (id)sender;

@end
