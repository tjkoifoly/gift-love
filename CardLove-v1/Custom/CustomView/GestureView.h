//
//  GestureView.h
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    GestureViewToEdit,
    GestureViewToView
} GestureViewType;


@class GestureView;
@protocol GestureViewDelegate <NSObject>

@optional

-(void) displayEditorWith:(GestureView *)gestureView forImage: (UIImage *) imageToEdit;
-(void) selectPhoto: (GestureView *) gestureView;
-(void) didLongPress: (GestureView *)gestureView;

@end

@interface GestureView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CALayer *shadowLayer;
@property (strong, nonatomic) CALayer *photoLayer;

@property (strong, nonatomic) NSString *imgURL;

@property (assign, nonatomic) id <GestureViewDelegate> delegate;

-(id) initWithType: (GestureViewType) type;
-(void) initialize;

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer;
- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer;
- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer;
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer;
- (void) tapSingleDetected :(UITapGestureRecognizer *)tapSigleRecognizer;

-(void) addLayersWithImage: (UIImage *)image;
-(void) selected: (BOOL) show;
-(void) updateMaskLayer;

@end
