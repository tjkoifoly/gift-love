//
//  ViewStyle.m
//  CardLove-v1
//
//  Created by FOLY on 3/22/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ViewStyle.h"

@implementation ViewStyle
{
    UIView *currentView;
}

@synthesize delegate;
@synthesize viewToEdit;
@synthesize segControl;
@synthesize viewBorder, viewColor, viewPattern;
@synthesize segProperty;
@synthesize lbWithOrOffset;
@synthesize slOpacity, slRadius, slWidthOrOffset;
@synthesize sliderColorBlue, sliderColorGreen, sliderColorRed;


-(void) awakeFromNib
{
    [super awakeFromNib];
    currentView = viewBorder;
    viewColor.hidden = YES;
    viewPattern.hidden = YES;
    [self addSubview:viewColor];
    [self addSubview:viewPattern];
    viewColor.frame = currentView.frame;
    viewPattern.frame = currentView.frame;
    
    [self loadComponents];
}

-(void) loadComponents
{
    [sliderColorRed setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlue setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    
    [sliderColorRed setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider1.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider2.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlue setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider3.png" ofType:nil]] forState:UIControlStateNormal];
    
    [sliderColorRed setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorGreen setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorBlue setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    
    [sliderColorRed addTarget:self action:@selector(updateColorRed:) forControlEvents:UIControlEventValueChanged];
    [sliderColorGreen addTarget:self action:@selector(updateColorGreen:) forControlEvents:UIControlEventValueChanged];
    [sliderColorBlue addTarget:self action:@selector(updateColorBlue:) forControlEvents:UIControlEventValueChanged];
    
    [sliderColorRed setMinimumValue:0.0f]; [sliderColorRed setMaximumValue:1.0f]; [sliderColorRed setValue:1.0f];
    [sliderColorGreen setMinimumValue:0.0f]; [sliderColorGreen setMaximumValue:1.0f]; [sliderColorGreen setValue:1.0f];
    [sliderColorBlue setMinimumValue:0.0f]; [sliderColorBlue setMaximumValue:1.0f]; [sliderColorBlue setValue:1.0f];

}

-(void) updateColorRed: (UISlider *) sender
{
    NSLog(@"Red = %f", sender.value);
}

-(void) updateColorGreen: (UISlider *) sender
{
    NSLog(@"Green = %f", sender.value);
}

-(void) updateColorBlue: (UISlider *) sender
{
    NSLog(@"Blue = %f", sender.value);
}

-(IBAction)updateBlackColor:(id)sender
{
    NSLog(@"Black");
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.layer.borderColor = [UIColor blackColor].CGColor;
        }
            break;
        case 1:
        {
            viewToEdit.layer.shadowColor = [UIColor blackColor].CGColor;
        }
            break;
            
        default:
            break;
    }

}

-(IBAction)updateWhiteColor:(id)sender
{
    NSLog(@"White");
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.layer.borderColor = [UIColor whiteColor].CGColor;
        }
            break;
        case 1:
        {
            viewToEdit.layer.shadowColor = [UIColor whiteColor].CGColor;
        }
            break;
            
        default:
            break;
    }

}

-(IBAction)segControlChanged:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"Border");
            if (viewBorder.hidden) {
                [UIView animateWithDuration:0.5 animations:^{
                    currentView.hidden = YES;
                } completion:^(BOOL finished) {
                    viewBorder.hidden = NO;
                    currentView = viewBorder;
                    
                }];
            }
        }
            break;
        case 1:
        {
            NSLog(@"Color");
            if (viewColor.hidden) {
                [UIView animateWithDuration:0.5 animations:^{
                    currentView.hidden = YES;
                } completion:^(BOOL finished) {
                    viewColor.hidden = NO;
                    currentView = viewColor;
                }];
            }
        }
            break;
        case 2:
        {
            NSLog(@"Parttern");
            if (viewPattern.hidden) {
                [UIView animateWithDuration:0.5 animations:^{
                    currentView.hidden = YES;
                } completion:^(BOOL finished) {
                    viewPattern.hidden = NO;
                    currentView = viewPattern;
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)stylePatternSelected:(id)sender
{
    NSLog(@"Button press = %i", [sender tag]);
}

-(IBAction)segPropertySeleted:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.layer.masksToBounds = YES;
            lbWithOrOffset.text = @"Width";
            
        }
            break;
        case 1:
        {
            viewToEdit.layer.masksToBounds = NO;
            viewToEdit.layer.borderWidth = 0.0f;
            lbWithOrOffset.text = @"Offset";
        }
            break;
        default:
            break;
    }
}

-(IBAction)updateWidthOrOffset:(UISlider *)sender
{
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"View to Edit %@", viewToEdit);
            viewToEdit.layer.borderWidth = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.layer.shadowOffset = CGSizeMake(sender.value, sender.value);
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)updateRadius:(UISlider *)sender
{
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.layer.cornerRadius = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.layer.shadowRadius = sender.value;
        }
            break;
            
        default:
            break;
    }

}

-(IBAction)updateOpacity:(UISlider *)sender
{
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.layer.opacity = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.layer.shadowOpacity = sender.value;
        }
            break;
            
        default:
            break;
    }

}



@end
