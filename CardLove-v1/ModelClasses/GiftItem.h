//
//  GiftItem.h
//  CardLove-v1
//
//  Created by FOLY on 3/16/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GestureImageView.h"
#import "GestureView.h"
#import "MacroDefine.h"

#define kClass      @"ofClass"
#define kFrame      @"frame"


@interface GiftItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString *ofClass;
@property (strong, nonatomic) NSString *frame;
@property (strong, nonatomic) NSString *bounds;
@property (strong, nonatomic) NSString *center;
@property (strong, nonatomic) NSString *transform;
@property (strong, nonatomic) NSString *photo;

- (id) initWithView:(GestureImageView*) imv;
- (id) initWithGestureView:(GestureView*) imv;

@end
