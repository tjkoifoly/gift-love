//
//  AddFriendViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NIDropDown.h"
#import "UIViewController+NibCells.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"

@interface AddFriendViewController : UIViewController <NIDropDownDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, EGORefreshTableHeaderDelegate>
{
    NIDropDown *dropDown;
    EGORefreshTableHeaderView *pullRefreshView;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UITextField *txtFindWord;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIImageView *imvBack;
@property (weak, nonatomic) IBOutlet UIImageView *imvTxtBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) NSMutableArray *result;

@end
