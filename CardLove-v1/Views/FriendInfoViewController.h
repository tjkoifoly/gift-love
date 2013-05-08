//
//  FriendInfoViewController.h
//  CardLove-v1
//
//  Created by FOLY on 5/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "FriendInfoCell.h"
#import "TapkuLibrary.h"

@interface FriendInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FriendInfoCellDelegate, TKCalendarMonthViewDataSource, TKCalendarMonthViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Friend *currentFriend;
@property (strong, nonatomic) NSMutableArray *specials;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property (strong,nonatomic) TKCalendarMonthView *monthViewCalendar;

@end
