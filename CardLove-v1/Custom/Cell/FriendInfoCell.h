//
//  FriendInfoCell.h
//  CardLove-v1
//
//  Created by FOLY on 5/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoCell;
@protocol FriendInfoCellDelegate <NSObject>

@optional
-(void) friendInfoCellOnDelete: (FriendInfoCell *) cell;

@end
@interface FriendInfoCell : UITableViewCell

@property (assign, nonatomic) id <FriendInfoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIImageView *imvSepar;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;

@end
