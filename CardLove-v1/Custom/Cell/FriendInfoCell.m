//
//  FriendInfoCell.m
//  CardLove-v1
//
//  Created by FOLY on 5/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendInfoCell.h"

@implementation FriendInfoCell

@synthesize lbContent,lbTitle;
@synthesize delegate;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    return self;
}
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

-(void) awakeFromNib
{
    

}

- (NSString *) reuseIdentifier {
    return @"FriendInfoCell";
}
- (IBAction)deleteThisCell:(id)sender {
    [self.delegate friendInfoCellOnDelete:self];
}

@end
