//
//  GiftElement.h
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"
#import "GestureImageView.h"

#define kElementID @"elementID"

@interface GiftElement : NSObject <NSCoding>

@property (strong, nonatomic) NSString *bounds;
@property (strong, nonatomic) NSString *center;
@property (strong, nonatomic) NSString *transform;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *elementID;

-(id) initWithGestureImageView: (GestureImageView *)giv;

@end
