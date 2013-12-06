//
//  GiftItem.m
//  CardLove-v1
//
//  Created by FOLY on 3/16/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftItem.h"

@implementation GiftItem

@synthesize ofClass, frame, transform, photo;
@synthesize borderColor, borderOpacity, borderWidth, borderRadius;
@synthesize shadowColor, shadowOffset, shadowOpacity, shadowRadius;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.ofClass = [aDecoder decodeObjectForKey:kClass];
        self.frame = [aDecoder decodeObjectForKey:kFrame];
        self.bounds = [aDecoder decodeObjectForKey:kBounds];
        self.center = [aDecoder decodeObjectForKey:kCenter];
        self.transform = [aDecoder decodeObjectForKey:kTransfrom];
        self.photo = [aDecoder decodeObjectForKey:kPhoto];
        self.borderWidth =[aDecoder decodeObjectForKey:kBorderWidth];
        self.borderOpacity = [aDecoder decodeObjectForKey:kBorderOpacity];
        self.borderColor = [aDecoder decodeObjectForKey:kBorderColor];
        self.borderRadius = [aDecoder decodeObjectForKey:kBorderRadius];
        self.shadowOpacity = [aDecoder decodeObjectForKey:kShadowOpacity];
        self.shadowOffset = [aDecoder decodeObjectForKey:kShadowOffset];
        self.shadowColor = [aDecoder decodeObjectForKey:kShadowColor];
        self.shadowRadius = [aDecoder decodeObjectForKey:kShadowRadius];
    }
    
    return self;

}

- (id) initWithGestureView:(GestureView*) imv
{
    self = [super init];
    if (self) {
        self.ofClass = NSStringFromClass(imv.class);
        self.frame = NSStringFromCGRect(imv.frame);
        self.transform = NSStringFromCGAffineTransform(imv.transform);
        self.bounds = NSStringFromCGRect(imv.bounds);
        self.center = NSStringFromCGPoint(imv.center);
        self.borderWidth = [NSString stringWithFormat:@"%f", imv.shadowLayer.borderWidth] ;
        self.borderOpacity = [NSString stringWithFormat:@"%f", imv.shadowLayer.opacity] ;
        self.borderRadius =  [NSString stringWithFormat:@"%f", imv.shadowLayer.cornerRadius] ;
        self.borderColor = [NSString stringWithFormat:@"%@", [UIColor colorWithCGColor:imv.shadowLayer.borderColor]] ;
        self.shadowOffset = NSStringFromCGSize(imv.shadowLayer.shadowOffset);
        self.shadowOpacity = [NSString stringWithFormat:@"%f", imv.shadowLayer.shadowOpacity] ;
        self.shadowRadius =  [NSString stringWithFormat:@"%f", imv.shadowLayer.shadowRadius] ;
        self.shadowColor = [NSString stringWithFormat:@"%@", [UIColor colorWithCGColor:imv.shadowLayer.shadowColor]] ;
        
        NSLog(@"TRANSFORM = %@", self.transform);
        self.photo = imv.imgURL;
        NSLog(@"IMAGE URL = %@",imv.imgURL);
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ofClass forKey:kClass];
    [aCoder encodeObject:self.frame forKey:kFrame];
    [aCoder encodeObject:self.transform forKey:kTransfrom];
    [aCoder encodeObject:self.photo forKey:kPhoto];
    [aCoder encodeObject:self.bounds forKey:kBounds];
    [aCoder encodeObject:self.center forKey:kCenter];
    [aCoder encodeObject:self.borderWidth forKey:kBorderWidth];
    [aCoder encodeObject:self.borderOpacity forKey:kBorderOpacity];
    [aCoder encodeObject:self.borderColor forKey:kBorderColor];
    [aCoder encodeObject:self.borderRadius forKey:kBorderRadius];
    [aCoder encodeObject:self.shadowOpacity forKey:kShadowOpacity];
    [aCoder encodeObject:self.shadowOffset forKey:kShadowOffset];
    [aCoder encodeObject:self.shadowColor forKey:kShadowColor];
    [aCoder encodeObject:self.shadowRadius forKey:kShadowRadius];
}



@end
