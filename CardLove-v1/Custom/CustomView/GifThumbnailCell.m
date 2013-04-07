//
//  GifThumbnailCell.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GifThumbnailCell.h"

@implementation GifThumbnailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (int i=0; i < 4; i++) {
            GifThumbnailView *thumbnailView = [[GifThumbnailView alloc] initWithFrame:CGRectMake(6+(72 * i + 6 * i), 6, 72, 72)];
            [thumbnailView setHidden:YES];
            thumbnailView.tag = i;
            [self addSubview:thumbnailView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(GifThumbnailView *) gifViewByTag: (NSInteger) tag
{
    for(id subview in [self subviews])
    {
        if ([subview isKindOfClass:[GifThumbnailView class]]) {
            
            if ([subview tag] == tag) {
                return subview;
            }
        }
    }
    return nil;
}


@end
