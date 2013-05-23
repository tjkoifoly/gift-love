//
//  FriendRequestCell.m
//  CardLove-v1
//
//  Created by FOLY on 5/23/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendRequestCell.h"

@implementation FriendRequestCell

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

- (IBAction)pressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(requestCell:withState:)]) {
        [self.delegate requestCell:self withState:(FriendType)[sender tag]];
    }
    
}

@end
