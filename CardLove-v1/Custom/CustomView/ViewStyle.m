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
@synthesize viewBorder, viewColor;
@synthesize segProperty;
@synthesize lbWithOrOffset;
@synthesize slOpacity, slRadius, slWidthOrOffset;
@synthesize sliderColorBlue, sliderColorGreen, sliderColorRed;


-(void) awakeFromNib
{
    [super awakeFromNib];
    currentView = viewBorder;
    viewColor.hidden = YES;
    [self addSubview:viewColor];
    viewColor.frame = currentView.frame;
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
    [self updateColor];
}

-(void) updateColorGreen: (UISlider *) sender
{
    NSLog(@"Green = %f", sender.value);
    [self updateColor];
}

-(void) updateColorBlue: (UISlider *) sender
{
    NSLog(@"Blue = %f", sender.value);
    [self updateColor];
}

-(void) updateColor
{
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"View to Edit %@", viewToEdit);
            viewToEdit.shadowLayer.borderColor = [UIColor colorWithRed:sliderColorRed.value green:sliderColorGreen.value blue:sliderColorBlue.value alpha:1].CGColor;
        }
            break;
        case 1:
        {
            viewToEdit.shadowLayer.shadowColor = [UIColor colorWithRed:sliderColorRed.value green:sliderColorGreen.value blue:sliderColorBlue.value alpha:1].CGColor;
        }
            break;
            
        default:
            break;
    }

}

-(IBAction)updateBlackColor:(id)sender
{
    NSLog(@"Black");
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            sliderColorRed.value = 0;
            sliderColorGreen.value = 0;
            sliderColorBlue.value = 0;
            viewToEdit.shadowLayer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
            
        }
            break;
        case 1:
        {
            sliderColorBlue.value = 0;
            sliderColorGreen.value = 0;
            sliderColorRed.value = 0;
            viewToEdit.shadowLayer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
        }
            break;
            
        default:
            break;
    }

    [viewToEdit setNeedsDisplay];
}

-(IBAction)updateWhiteColor:(id)sender
{
    sliderColorBlue.value = 1;
    sliderColorGreen.value = 1;
    sliderColorRed.value = 1;
    NSLog(@"White");
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.shadowLayer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
        }
            break;
        case 1:
        {
            viewToEdit.shadowLayer.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
        }
            break;
            
        default:
            break;
    }
        [viewToEdit setNeedsDisplay];

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
                    switch (segProperty.selectedSegmentIndex) {
                        case 0:
                        {
                            [self loadBorder];
                        }
                            break;
                        case 1:
                        {
                            [self loadShadow];
                        }
                            break;
                            
                        default:
                            break;
                    }
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
                    switch (segProperty.selectedSegmentIndex) {
                        case 0:
                        {
                            UIColor *color = [UIColor colorWithCGColor:viewToEdit.shadowLayer.borderColor];
                            const CGFloat* components = CGColorGetComponents(color.CGColor);
                                                    
                            sliderColorRed.value = components[0];
                            NSLog(@"%f", components[0]);
                            sliderColorGreen.value = components[1];
                            NSLog(@"%f", components[1]);
                            sliderColorBlue.value = components[2];
                            NSLog(@"%f", components[2]);

                        }
                            break;
                        case 1:
                        {
                            UIColor *color = [UIColor colorWithCGColor:viewToEdit.shadowLayer.shadowColor];
                            const CGFloat* components = CGColorGetComponents(color.CGColor);
                            
                            sliderColorRed.value = components[0];
                            NSLog(@"%f", components[0]);
                            sliderColorGreen.value = components[1];
                            NSLog(@"%f", components[1]);
                            sliderColorBlue.value = components[2];
                            NSLog(@"%f", components[2]);
                        }
                            break;
                            
                        default:
                            break;
                    }

                    
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void) loadBorder
{
    lbWithOrOffset.text = @"Width";
    slWidthOrOffset.value = viewToEdit.shadowLayer.borderWidth ;
    slRadius.value = viewToEdit.shadowLayer.cornerRadius ;
    slOpacity.value = viewToEdit.photoLayer.opacity;
}

-(void) loadShadow
{
    lbWithOrOffset.text = @"Offset";
    slWidthOrOffset.value = viewToEdit.shadowLayer.shadowOffset.width;
    slRadius.value = viewToEdit.shadowLayer.shadowRadius;
    slOpacity.value = viewToEdit.shadowLayer.shadowOpacity;
}


-(IBAction)segPropertySeleted:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [self loadBorder];
            
        }
            break;
        case 1:
        {
            [self loadShadow];
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
            viewToEdit.shadowLayer.borderWidth = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.shadowLayer.shadowOffset = CGSizeMake(sender.value, sender.value);
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
            viewToEdit.shadowLayer.cornerRadius = sender.value;
            viewToEdit.photoLayer.cornerRadius = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.shadowLayer.shadowRadius = sender.value;
        
        }
            break;
            
        default:
            break;
    }
    [viewToEdit updateMaskLayer];
    [viewToEdit setNeedsDisplay];

}

-(IBAction)updateOpacity:(UISlider *)sender
{
    switch (segProperty.selectedSegmentIndex) {
        case 0:
        {
            viewToEdit.photoLayer.opacity = sender.value;
        }
            break;
        case 1:
        {
            viewToEdit.shadowLayer.shadowOpacity = sender.value;
        }
            break;
            
        default:
            break;
    }

}

-(IBAction)closeViewStyle:(id)sender
{
    [self.delegate viewStyleClosed:self];
}


@end
