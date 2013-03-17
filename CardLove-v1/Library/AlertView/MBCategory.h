//
//  MBCategory.h
//  Randomizr
//
//  Created by Ethan Kramer on 5/20/11.
//  Copyright 2011 Ethan Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (MBCategory)

+(UIColor *)colorWithHex:(UInt32)col;
+(UIColor *)colorWithHexString:(NSString *)str;

@end
