//
//  GestureView.h
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureView : UIView <UIGestureRecognizerDelegate>


-(void) initialize;

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer;
- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer;
- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer;
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer;
- (void) tapSingleDetected :(UITapGestureRecognizer *)tapSigleRecognizer;

@end
