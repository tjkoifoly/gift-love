//
//  GiftLabel.h
//  CardLove-v1
//
//  Created by FOLY on 3/28/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GestureLabel.h"
#import "GiftItem.h"

#define kText       @"text"
#define kFontName   @"fontName"
#define kFontSize   @"fontSize"
#define kTextColor  @"textColor"

@interface GiftLabel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *bounds;
@property (strong, nonatomic) NSString *center;
@property (strong, nonatomic) NSString *transform;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) NSString *fontSize;
@property (strong, nonatomic) NSString *textColor;

-(id) initWithGestureLabel: (GestureLabel *) gLabel;

@end
