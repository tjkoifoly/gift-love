//
//  ViewStyle.h
//  CardLove-v1
//
//  Created by FOLY on 3/22/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ViewStyle;

@protocol ViewStyleDelegate <NSObject>


@end

@interface ViewStyle : UIView

@property (assign, nonatomic) id<ViewStyleDelegate> delegate;
@property (assign, nonatomic) UIView *viewToEdit;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UIView *viewBorder;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segProperty;
@property (strong, nonatomic) IBOutlet UILabel *lbWithOrOffset;
@property (strong, nonatomic) IBOutlet UISlider *slWidthOrOffset;
@property (strong, nonatomic) IBOutlet UISlider *slRadius;
@property (strong, nonatomic) IBOutlet UISlider *slOpacity;

@property (strong, nonatomic) IBOutlet UIView *viewColor;
@property (strong, nonatomic) IBOutlet UISlider *sliderColorRed;
@property (strong, nonatomic) IBOutlet UISlider *sliderColorGreen;
@property (strong, nonatomic) IBOutlet UISlider *sliderColorBlue;

@property (strong, nonatomic) IBOutlet UIView *viewPattern;

-(IBAction)segControlChanged:(id)sender;
-(IBAction)stylePatternSelected:(id)sender;
-(IBAction)segPropertySeleted:(id)sender;
-(IBAction)updateBlackColor:(id)sender;
-(IBAction)updateWhiteColor:(id)sender;


@end
