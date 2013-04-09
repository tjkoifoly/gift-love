//
//  GestureView.m
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView
{
     CALayer *_maskingLayer;
}

@synthesize shadowLayer     = _shadowLayer;
@synthesize photoLayer      = _photoLayer;
@synthesize imgURL          = _imgURL;
@synthesize delegate        = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(id) initWithType: (GestureViewType) type
{
    self = [super init];
    if (self) {
        switch (type) {
            case GestureViewToEdit:
            {
                [self initialize];
            }
                break;
            case GestureViewToView:
            {
                [self initializeToView];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void) initialize
{
    // Initialization code
    
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:[UIColor clearColor]];

    self.layer.masksToBounds = NO;
    
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


-(void) initializeToView
{
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tapSigleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapSigleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapSigleRecognizer];
    tapSigleRecognizer.delegate = self;

}

#pragma mark - Gesture Delegate

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    [self.delegate selectPhoto:self];
    CGPoint translation = [panRecognizer translationInView:self.superview];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    [self.delegate selectPhoto:self];
    CGFloat scale = pinchRecognizer.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    [self.delegate selectPhoto:self];
    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    UIImage *image = [UIImage imageWithCGImage:(CGImageRef)_photoLayer.contents];
  
    [self.delegate displayEditorWith:self forImage:image];
    [self.delegate selectPhoto:self];
    
}
-(void) tapSingleDetected :(UITapGestureRecognizer *)tapSigleRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.superview bringSubviewToFront:self];
       
    }completion:^(BOOL finished) {
        [self.delegate selectPhoto:self];
    }];
}

-(void) tapAction: (UITapGestureRecognizer *) tapSigleRecognizer
{
    NSLog(@"View has been tapped.");
}

#pragma mark - 
#pragma mark - Layer
-(void) addLayersWithImage: (UIImage *)image
{
    _shadowLayer = [CALayer layer];
    _shadowLayer.backgroundColor = [UIColor blueColor].CGColor;
    _shadowLayer.shadowOffset = CGSizeMake(0, 3);
    _shadowLayer.shadowRadius = 5.0;
    _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    _shadowLayer.shadowOpacity = 0.8;
    _shadowLayer.frame = self.bounds;
    _shadowLayer.borderColor = [UIColor blackColor].CGColor;
    _shadowLayer.borderWidth = 2.0;
    _shadowLayer.cornerRadius = 10.0;
    [self.layer addSublayer:_shadowLayer];
    
    _photoLayer = [CALayer layer];
    _photoLayer.frame = _shadowLayer.bounds;
    _photoLayer.cornerRadius = 10.0;
    _photoLayer.contents = (id) image.CGImage;
    _photoLayer.masksToBounds = YES;
    [_shadowLayer addSublayer:_photoLayer];
    
    NSLog(@"Image = %@", image);

}

#pragma mark - Selection
-(void) selected: (BOOL) show
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
    
    _maskingLayer.cornerRadius = _photoLayer.cornerRadius;
    _maskingLayer.masksToBounds = NO;
    [self.layer addSublayer:_maskingLayer];
}

-(void) removeMaskLayer
{
    [_maskingLayer removeFromSuperlayer];
    _maskingLayer = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end
