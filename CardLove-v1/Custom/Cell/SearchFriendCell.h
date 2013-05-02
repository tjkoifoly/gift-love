//
//  SearchFriendCell.h
//  CardLove-v1
//
//  Created by FOLY on 5/2/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsManager.h"
#import "NKToggleOverlayButton.h"

@interface SearchFriendCell : UITableViewCell

@property (unsafe_unretained, nonatomic) Friend *friendObject;
@property (weak, nonatomic) IBOutlet UIImageView *imvAvata;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet NKToggleOverlayButton *btnFriend;

-(void) reloadCell;

@end
