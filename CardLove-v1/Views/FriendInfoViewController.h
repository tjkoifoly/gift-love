//
//  FriendInfoViewController.h
//  CardLove-v1
//
//  Created by FOLY on 5/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface FriendInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Friend *currentFriend;

@end
