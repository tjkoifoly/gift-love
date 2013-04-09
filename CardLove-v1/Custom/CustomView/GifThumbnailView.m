//
//  GifThumbnailView.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GifThumbnailView.h"

@implementation GifThumbnailView
{
    CALayer *_layerCheckmark;
}
@synthesize imageName = _imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        [self setContentMode:UIViewContentModeRedraw];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

-(void)tapDetected: (UITapGestureRecognizer *) tapRecognizer
{
    NSLog(@"Tap is detected: %@", self.image);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGifSelected object:self  userInfo: nil];
}

-(void) selected: (BOOL) select
{
    if (select) {
        
        UIColor *bgColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.layer.backgroundColor = bgColor.CGColor;
        
        UIImage *img = [UIImage imageNamed:@"icon-checkmark.png"];
        CGSize imgSize = img.size;
        
        _layerCheckmark = [CALayer layer];
        CGRect frame = self.frame;
        _layerCheckmark.frame = CGRectMake(frame.size.width - imgSize.width, frame.size.height - imgSize.height, imgSize.width, imgSize.height);
        _layerCheckmark.contents = (id) img.CGImage;
        _layerCheckmark.masksToBounds = YES;
        [self.layer addSublayer:_layerCheckmark];
    }else
    {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [_layerCheckmark removeFromSuperlayer];
    }
}



@end
