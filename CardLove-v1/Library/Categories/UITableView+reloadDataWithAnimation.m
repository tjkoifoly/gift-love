//
//  UITableView+reloadDataWithAnimation.m
//  CardLove-v1
//
//  Created by FOLY on 4/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UITableView+reloadDataWithAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableView (reloadDataWithAnimation)

- (void)reloadData:(BOOL)animated
{
    [self reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}

@end
