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
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchFriendCell : UITableViewCell <NKToggleOverlayButtonDelegate>

@property (weak, nonatomic) IBOutlet EGOImageView *imvAvata;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet NKToggleOverlayButton *btnFriend;

-(void) becomFriend;
- (void)setPhoto:(NSString*)photo;
- (void)willMoveToSuperview:(UIView *)newSuperview;
@end
