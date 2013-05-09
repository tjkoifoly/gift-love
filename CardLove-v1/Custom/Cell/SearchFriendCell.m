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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithCoder:(NSCoder *)aDecoder;
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.btnFriend = [[NKToggleOverlayButton alloc] init];
        self.btnFriend.frame = CGRectMake(0, 0, 27, 31);
        self.btnFriend.center = CGPointMake(286, 25);
        [self.btnFriend setOnImage:[UIImage imageNamed:@"Check (Selected).png"] forState:UIControlStateNormal];
        [self.btnFriend setOnImage:[UIImage imageNamed:@"Close Safari Page Button.png"] forState:UIControlStateHighlighted];
        [self.btnFriend setOffImage:[UIImage imageNamed:@"Check (Unslected).png"] forState:UIControlStateNormal];
        [self.btnFriend setOffImage:[UIImage imageNamed:@"Check (Selected).png"] forState:UIControlStateHighlighted];
        self.btnFriend.overlayOnText = @"Friend request";
        self.btnFriend.overlayOffText = @"Unfriend";
        
        id weakSelf = (typeof (self)) self;
        
        self.btnFriend.toggleOnBlock = ^(NKToggleOverlayButton *button) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendFriendRequest object: weakSelf];
        };
        self.btnFriend.toggleOffBlock = ^(NKToggleOverlayButton *button) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendFriendRequest object: weakSelf];
            NSLog(@"Unfriend");
        };

        
        [self addSubview:self.btnFriend];

    }
    return self;
}

-(void) awakeFromNib
{
    //
    
   
}

- (NSString *) reuseIdentifier {
    return @"SearchFriendCell";
}

-(void) addF
{
    
}

@end
