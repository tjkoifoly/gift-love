//
//  GestureLabel.h
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+dynamicSizeMe.h"
#import "THLabel.h"
#import "FXLabel.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    GestureLabelToEdit,
    GestureLabelToView
}GestureLabelType;

@class GestureLabel;
@protocol GestureLabelDelegate <NSObject>

-(void) displayEditorFor: (GestureLabel *) label ;
-(void) gestureLabelDidSelected: (GestureLabel *) label;

@end

@interface GestureLabel : FXLabel <UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSString* labelID;
@property (strong, nonatomic) UIImageView *resizeImage;
@property (strong, nonatomic) UIGestureRecognizer *panRecognizer;

@property (assign, nonatomic) id<GestureLabelDelegate> delegate;

-(id) initWithType: (GestureLabelType) type;

-(void) labelSelected;
-(void) labelDeselected;

@end
