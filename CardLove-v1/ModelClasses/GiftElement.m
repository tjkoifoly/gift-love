//
//  GiftElement.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftElement.h"

@implementation GiftElement

@synthesize bounds = _bounds;
@synthesize center = _center;
@synthesize transform = _transform;
@synthesize imageURL = _imageURL;
@synthesize elementID = _elementID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _bounds = [aDecoder decodeObjectForKey:kBounds];
        _center = [aDecoder decodeObjectForKey:kCenter];
        _transform = [aDecoder decodeObjectForKey:kTransfrom];
        _imageURL = [aDecoder decodeObjectForKey:kImgURL];
        _elementID = [aDecoder decodeObjectForKey:kElementID];
    }
    return self;
}

-(id) initWithGestureImageView:(GestureImageView *)giv
{
    self = [super init];
    if (self) {
        _bounds = NSStringFromCGRect(giv.bounds);
        _center = NSStringFromCGPoint(giv.center);
        _transform = NSStringFromCGAffineTransform(giv.transform);
        _imageURL = giv.imgURL;
        _elementID = giv.elementID;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_bounds forKey:kBounds];
    [aCoder encodeObject:_center forKey:kCenter];
    [aCoder encodeObject:_transform forKey:kTransfrom];
    [aCoder encodeObject:_imageURL forKey:kImgURL];
    [aCoder encodeObject:_elementID forKey:kElementID];
}

@end
