//
//  FriendRequestCell.h
//  CardLove-v1
//
//  Created by FOLY on 5/23/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

@class FriendRequestCell;
@protocol FriendRequestCellDelegate <NSObject>

@optional
-(void) requestCell:(FriendRequestCell *)cell withState:(FriendType) state;

@end

@interface FriendRequestCell : UITableViewCell

@property (unsafe_unretained, nonatomic) id<FriendRequestCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNick;
@property (weak, nonatomic) IBOutlet UIImageView *imvAvarta;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDeny;

- (IBAction)pressed:(id)sender ;

@end
