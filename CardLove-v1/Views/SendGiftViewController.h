//
//  SendGiftViewController.h
//  CardLove-v1
//
//  Created by FOLY on 5/13/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "FunctionObject.h"
#import "MBProgressHUD.h"
@class SendGiftViewController;
@protocol SendGiftViewControllerDelegate <NSObject>

@optional
-(void) sendGiftViewController:(SendGiftViewController *)sgvc didSendGift:(NSString *)path withParams:(NSDictionary *) dictParams;

@end

@interface SendGiftViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (assign, nonatomic) id<SendGiftViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell;
@property (strong, nonatomic) Friend *toFriend;
@property (strong, nonatomic) NSString *pathGift;

@property (nonatomic) BOOL isPresenting;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtGiftName;
@property (weak, nonatomic) IBOutlet UITextField *txtDateChoose;

@property (strong, nonatomic) UIDatePicker * datePicker;

@end
