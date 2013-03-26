//
//  PreviewCell.m
//  CardLove-v1
//
//  Created by FOLY on 3/26/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "PreviewCell.h"

@implementation PreviewCell

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

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch cell CELL");
    // If not dragging, send event to next responder
    [super touchesEnded: touches withEvent: event];
}

@end
