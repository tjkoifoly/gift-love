//
//  GiftLabel.m
//  CardLove-v1
//
//  Created by FOLY on 3/28/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftLabel.h"

@implementation GiftLabel

@synthesize bounds, center, transform, text, fontName,fontSize, textColor, labelID;

-(id) initWithGestureLabel: (GestureLabel *) gLabel
{
    self = [super init];
    if (self) {
        self.labelID = gLabel.labelID;
        self.bounds = NSStringFromCGRect(gLabel.bounds);
        self.center = NSStringFromCGPoint(gLabel.center);
        self.transform = NSStringFromCGAffineTransform(gLabel.transform);
        self.text = gLabel.text;
        self.fontName = gLabel.font.fontName;
        self.fontSize = [NSString stringWithFormat:@"%f", gLabel.font.pointSize];
        self.textColor = [NSString stringWithFormat:@"%@", gLabel.textColor];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.labelID = [aDecoder decodeObjectForKey:klabelID];
        self.bounds = [aDecoder decodeObjectForKey:kBounds];
        self.center = [aDecoder decodeObjectForKey:kCenter];
        self.transform = [aDecoder decodeObjectForKey:kTransfrom];
        self.text = [aDecoder decodeObjectForKey:kText];
        self.textColor = [aDecoder decodeObjectForKey:kTextColor];
        self.fontName = [aDecoder decodeObjectForKey:kFontName];
        self.fontSize = [aDecoder decodeObjectForKey:kFontSize];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.labelID forKey:klabelID];
    [aCoder encodeObject:self.bounds forKey:kBounds];
    [aCoder encodeObject:self.center forKey:kCenter];
    [aCoder encodeObject:self.transform forKey:kTransfrom];
    [aCoder encodeObject:self.text forKey:kText];
    [aCoder encodeObject:self.textColor forKey:kTextColor];
    [aCoder encodeObject:self.fontName forKey:kFontName];
    [aCoder encodeObject:self.fontSize forKey:kFontSize];
}

@end
