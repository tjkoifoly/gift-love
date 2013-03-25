//
//  GestureLabel.m
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GestureLabel.h"

@implementation GestureLabel
{
    BOOL _resizing;
}

@synthesize resizeImage = _resizeImage;
@synthesize panRecognizer = _panRecognizer;

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
    self.textAlignment = UITextAlignmentCenter;
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self addGestureRecognizer:_panRecognizer];
    _panRecognizer.delegate = self;
    
//    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
//    [self addGestureRecognizer:pinchRecognizer];
//    pinchRecognizer.delegate = self;
    
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
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        if (_resizeImage) {
            CGPoint touchPoint = [panRecognizer locationInView:self];
            if (touchPoint.x > _resizeImage.frame.origin.x && touchPoint.y > _resizeImage.frame.origin.y) {
                _resizing = YES;
            }else
            {
                _resizing = NO;
            }
        }

    }else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (_resizing) {
            CGPoint translation = [panRecognizer translationInView:self.superview];
            
            CGFloat translationX = translation.x ;
            CGFloat translationY = translation.y ;
            
            CGRect bounds = [self bounds];
            CGPoint center = self.center;
            
            bounds.size.width += translationX;
            if (bounds.size.width < _resizeImage.bounds.size.width) {
                bounds.size.width = _resizeImage.bounds.size.width;
            }
            
            //frame.size.height += translation.y;
            bounds.size.height += translationY;
            if (bounds.size.height < _resizeImage.bounds.size.height) {
                bounds.size.height = _resizeImage.bounds.size.height;
            }
            
            self.bounds = bounds;
            
            center.x += translationX/2;
            center.y += translationY/2;
            self.center = center;
            
            
            [self autoFitTextWithFrame];
            
            UIImage *image = [UIImage imageNamed:@"resize.png"];
            _resizeImage.center = CGPointMake(self.bounds.size.width - image.size.width/2 , self.bounds.size.height - image.size.height/2);
            
            [panRecognizer setTranslation:CGPointZero inView:self.superview];
        }else{
            CGPoint translation = [panRecognizer translationInView:self.superview];
            CGPoint imageViewPosition = self.center;
            imageViewPosition.x += translation.x;
            imageViewPosition.y += translation.y;
            
            self.center = imageViewPosition;
            [panRecognizer setTranslation:CGPointZero inView:self.superview];
        }
    }else if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        _resizing = NO;
    }else if (panRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        _resizing = NO;
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale;
    
    CGRect frame = self.frame;
    frame.size.width *= scale;
    frame.size.height *= scale;

    self.frame = frame;
    
    [self autoFitTextWithFrame];
    
    if (_resizeImage) {
        UIImage *image = [UIImage imageNamed:@"resize.png"];
        [UIView animateWithDuration:0.1 animations:^{
            _resizeImage.center = CGPointMake(self.bounds.size.width - image.size.width/2 , self.bounds.size.height - image.size.height/2);
        }];
    }
    
//    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    
    CGFloat radiansAlpha = atan2f(self.transform.b, self.transform.a);
    CGFloat degrees = radiansAlpha * (180 / M_PI);
    NSLog(@"DCM %f", degrees);
    
    //NSLog(@"Angle = %f", angle);
    rotationRecognizer.rotation = 0.0;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [self labelDeselected];
}
-(void) tapSingleDetected :(UITapGestureRecognizer *)tapSigleRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.superview bringSubviewToFront:self];
        
    } completion:^(BOOL finished) {
        [self labelSelected];
    }];
}

-(void) autoFitTextWithFrame
{
    NSString *theText = self.text;
    CGRect labelRect = self.bounds;
    self.adjustsFontSizeToFitWidth = NO;
    self.numberOfLines = 0;
    
    CGFloat fontSize = 100;
    UIFont *font = self.font;
    while (fontSize > 4)
    {
        CGSize size = [theText sizeWithFont:[UIFont fontWithName:font.fontName size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= labelRect.size.height) break;
        
        fontSize -= 1.0;
    }
    
    //set font size
    self.font = [UIFont fontWithName:font.fontName size:fontSize];
}

-(void) labelSelected
{
    [self setBackgroundColor:[UIColor colorWithRed:115/255 green:115/255 blue:115/255 alpha:0.5]];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    if (!_resizeImage) {
        UIImage *image = [UIImage imageNamed:@"resize.png"];
        _resizeImage = [[UIImageView alloc] initWithImage:image];
        _resizeImage.center = CGPointMake(self.bounds.size.width - image.size.width/2 , self.bounds.size.height - image.size.height/2);
        [self addSubview:_resizeImage];
    }
}

-(void) labelDeselected
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.layer.borderWidth = 0.0f;
    [self.resizeImage removeFromSuperview];
    self.resizeImage = nil;
}


@end
