//
//  SearchFriendCell.m
//  CardLove-v1
//
//  Created by FOLY on 5/2/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "SearchFriendCell.h"


@implementation SearchFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithCoder:(NSCoder *)aDecoder;
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.btnFriend = [[NKToggleOverlayButton alloc] init];
        self.btnFriend.frame = CGRectMake(0, 0, 31, 31);
        self.btnFriend.center = CGPointMake(286, 25);
        [self.btnFriend setOnImage:[UIImage imageNamed:@"Check (Selected).png"] forState:UIControlStateNormal];
        [self.btnFriend setOnImage:[UIImage imageNamed:@"Close Safari Page Button.png"] forState:UIControlStateHighlighted];
        [self.btnFriend setOffImage:[UIImage imageNamed:@"Check (Unslected).png"] forState:UIControlStateNormal];
        [self.btnFriend setOffImage:[UIImage imageNamed:@"Check (Selected).png"] forState:UIControlStateHighlighted];
        self.btnFriend.overlayOnText = @"Friend request";
        self.btnFriend.overlayOffText = @"Unfriend";
    
        self.btnFriend.delegate = self;
        
//        id weakSelf = (typeof (self)) self;
//        self.btnFriend.toggleOnBlock = ^(NKToggleOverlayButton *button) {
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendFriendRequest object: weakSelf];
//        };
//        self.btnFriend.toggleOffBlock = ^(NKToggleOverlayButton *button) {
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendFriendRequest object: weakSelf];
//            NSLog(@"Unfriend");
//        };
        
        [self addSubview:self.btnFriend];
        
        [self.imvAvata setPlaceholderImage:[UIImage imageNamed:@"noavata.png"]];

    }
    return self;
}

- (void)setPhoto:(NSString*)photo {
	self.imvAvata.imageURL = [NSURL URLWithString:photo];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[self.imvAvata cancelImageLoad];
	}
}

-(void) becomFriend
{
    self.btnFriend.hidden = YES;
    
    UIImageView *imv =(UIImageView *) [self viewWithTag:999];
    if (imv) {
        imv.hidden = NO;
    }else{
        imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick-green.png"]];
        imv.frame = CGRectMake(0, 0, 28, 28);
        imv.center = CGPointMake(286, 25);
        imv.tag = 999;
        [self addSubview:imv];
    }
    
}

-(void) awakeFromNib
{
    [super awakeFromNib];
   
}

- (NSString *) reuseIdentifier {
    return @"SearchFriendCell";
}

-(void) toggleButtonDidToggle:(NKToggleOverlayButton *)button
{
    BOOL status = button.isOn;
    NSLog(@"%s", status?"ON":"OFF");
    if (status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendFriendRequest object: self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCancelFriendRequest object: self];
    }
}



@end
