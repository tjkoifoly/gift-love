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
@property (strong, nonatomic) NSString* borderWidth;
@property (strong, nonatomic) NSString* borderOpacity;
@property (strong, nonatomic) NSString * borderColor;
@property (strong, nonatomic) NSString *borderRadius;
@property (strong, nonatomic) NSString * shadowOpacity;
@property (strong, nonatomic) NSString *shadowOffset;
@property (strong, nonatomic) NSString *shadowColor;
@property (strong, nonatomic) NSString *shadowRadius;


- (id) initWithGestureView:(GestureView*) imv;

@end
