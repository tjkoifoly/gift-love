//
//  GestureView.m
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) initialize
{
    // Initialization code
    
    self.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self addGestureRecognizer:pinchRecognizer];
    pinchRecognizer.delegate = self;
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self addGestureRecognizer:rotationRecognizer];
    rotationRecognizer.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
    tapRecognizer.delegate = self;
    
    UITapGestureRecognizer *tapSigleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleDetected:)];
    tapSigleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapSigleRecognizer];
    tapSigleRecognizer.delegate = self;
    
}

#pragma mark - Gesture Delegate

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:self.superview];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{

}
-(void) tapSingleDetected :(UITapGestureRecognizer *)tapSigleRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.superview bringSubviewToFront:self];
       
    }];
}


@end
