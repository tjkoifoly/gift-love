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
    }
    
    return self;

}

-(id) initWithView:(GestureImageView *)imv
{
    self = [super init];
    if (self) {
        self.ofClass = NSStringFromClass(imv.class);
        self.frame = NSStringFromCGRect(imv.frame);
        self.transform = NSStringFromCGAffineTransform(imv.transform);
        self.bounds = NSStringFromCGRect(imv.bounds);
        self.center = NSStringFromCGPoint(imv.center);
        
        NSLog(@"TRANSFORM = %@", self.transform);
        
        self.photo = imv.imgURL;
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
}



@end
