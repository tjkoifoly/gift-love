//
//  SearchFriendCell.m
//  CardLove-v1
//
//  Created by FOLY on 5/2/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "SearchFriendCell.h"

@implementation SearchFriendCell

@synthesize friendObject =_friendObject;

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

-(void) reloadCell
{
    
    if (_friendObject) {
        self.lbName.text = _friendObject.displayName;
        self.btnFriend.toggleOnBlock = ^(NKToggleOverlayButton *button) {
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
        };
        self.btnFriend.toggleOffBlock = ^(NKToggleOverlayButton *button) {
            NSLog(@"Unfriend");
        };

    }
}

-(void) awakeFromNib
{
    //
    
    self.btnFriend = [[NKToggleOverlayButton alloc] init];
    self.btnFriend.frame = CGRectMake(0, 0, 27, 31);
    self.btnFriend.center = CGPointMake(286, 25);
    [self.btnFriend setOnImage:[UIImage imageNamed:@"tick-on.png"] forState:UIControlStateNormal];
    [self.btnFriend setOnImage:[UIImage imageNamed:@"tick-on-press.png"] forState:UIControlStateHighlighted];
    [self.btnFriend setOffImage:[UIImage imageNamed:@"tick-off.png"] forState:UIControlStateNormal];
    [self.btnFriend setOffImage:[UIImage imageNamed:@"tick-off-press.png"] forState:UIControlStateHighlighted];
    self.btnFriend.overlayOnText = @"Friend";
    self.btnFriend.overlayOffText = @"Unfriend";
        
     [self addSubview:self.btnFriend];

}

-(void) addF
{
    
}

@end
