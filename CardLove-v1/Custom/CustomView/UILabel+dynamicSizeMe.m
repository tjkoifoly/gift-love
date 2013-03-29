//
//  UILabel+dynamicSizeMe.m
//  CardLove-v1
//
//  Created by FOLY on 3/20/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UILabel+dynamicSizeMe.h"

@implementation UILabel(dynamicSizeMe)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:UILineBreakModeWordWrap];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];

    if (expectedLabelSize.height < 32) {
        return 32;
    }
    return expectedLabelSize.height;
}

-(void)resizeToStretch{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.width;
}

-(void) autoFitTextWithFrame
{
    NSString *theText = self.text;
    CGRect labelRect = self.bounds;
    self.adjustsFontSizeToFitWidth = NO;
    self.numberOfLines = 0;
    
    CGFloat fontSize = 100;
    UIFont *font = self.font;
    while (fontSize > 4)
    {
        CGSize size = [theText sizeWithFont:[UIFont fontWithName:font.fontName size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= labelRect.size.height) break;
        
        fontSize -= 1.0;
    }
    
    //set font size
    self.font = [UIFont fontWithName:font.fontName size:fontSize];
}


@end
