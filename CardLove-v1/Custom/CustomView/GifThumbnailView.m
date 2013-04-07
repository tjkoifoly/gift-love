//
//  GifThumbnailView.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GifThumbnailView.h"

@implementation GifThumbnailView

@synthesize borderColor = _borderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor blackColor];
        self.layer.borderColor = self.borderColor.CGColor;
        self.layer.borderWidth = 1.0f;
        [self setContentMode:UIViewContentModeCenter];
        self.clipsToBounds = YES;
    }
    return self;
}


@end
