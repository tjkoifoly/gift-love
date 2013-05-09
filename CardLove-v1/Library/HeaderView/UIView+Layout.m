//
//  UIView+Layout.m
//  CardLove-v1
//
//  Created by FOLY on 5/10/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)setNeedsLayoutRecursively {
    for (UIView *view in self.subviews) {
        [view setNeedsLayoutRecursively];
    }
    [self setNeedsLayout];
}

@end

