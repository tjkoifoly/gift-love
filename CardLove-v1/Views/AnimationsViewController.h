//
//  AnimationsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/1/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIEffectDesignerView.h"

#define kNoEff @"no-eff"

@class AnimationsViewController;
@protocol AnimationViewControllerDelegate <NSObject>

-(void) animationViewControllerCancel;
-(void) animationVIewControllerDone: (NSString *) strEffect;

@end

@interface AnimationsViewController : UIViewController

@property (assign, nonatomic) id <AnimationViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *listAnimations;
@property (strong, nonatomic) NSString *currentEffect;

@end
