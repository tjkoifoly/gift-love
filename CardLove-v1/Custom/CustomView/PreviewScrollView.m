//
//  PreviewScrollView.m
//  CardLove-v1
//
//  Created by FOLY on 3/26/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "PreviewScrollView.h"

@implementation PreviewScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch scroll");
    // If not dragging, send event to next responder
    if (!self.dragging)
        [self.nextResponder touchesEnded: touches withEvent:event];
    else
        [super touchesEnded: touches withEvent: event];
}

@end
