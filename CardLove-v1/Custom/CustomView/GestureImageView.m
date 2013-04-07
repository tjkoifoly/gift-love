//
//  GestureImageView.m
//  CardLove-v1
//
//  Created by FOLY on 3/9/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GestureImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GestureImageView
{
    CALayer *_maskingLayer;
}

@synthesize delegate;
@synthesize imgURL = _imgURL;
@synthesize elementID = _elementID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    // Initialization code
    
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    
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
    
    UITapGestureRecognizer *tapSigleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDCM:)];
    tapSigleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapSigleRecognizer];
    tapSigleRecognizer.delegate = self;

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6];
    [[UIColor greenColor] set];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
}

#pragma mark - Instance Methods
-(void) showShadow:(BOOL) show
{
    if(show)
    {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.layer.shadowOpacity = self.layer.opacity;
        self.layer.shadowRadius = self.layer.cornerRadius;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }else
    {
        self.layer.masksToBounds = YES;
    }
    
}

-(void) showBorder: (BOOL) show
{
    if (show) {
        [self addMaskLayer];
    }else{
        [self removeMaskLayer];
    }
    
}

- (void) addMaskLayer
{
    if (_maskingLayer) {
        return;
    }
    _maskingLayer = [CALayer layer];
    _maskingLayer.frame = self.bounds;
    _maskingLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    
    _maskingLayer.cornerRadius = self.layer.cornerRadius;
    _maskingLayer.masksToBounds = NO;
    [self.layer addSublayer:_maskingLayer];
}

-(void) removeMaskLayer
{
    [_maskingLayer removeFromSuperlayer];
    _maskingLayer = nil;
}

#pragma mark - Gesture Delegate

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    [self.delegate selectImageView:self];
    CGPoint translation = [panRecognizer translationInView:self.superview];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    [self.delegate selectImageView:self];
    CGFloat scale = pinchRecognizer.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    [self.delegate selectImageView:self];
    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    rotationRecognizer.rotation = 0.0;
    
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [self.delegate selectImageView:self];
}

-(void) tapDCM :(UITapGestureRecognizer *)tapSigleRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.superview bringSubviewToFront:self];
        
    }completion:^(BOOL finished) {
        [self.delegate selectImageView:self];
    }];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
