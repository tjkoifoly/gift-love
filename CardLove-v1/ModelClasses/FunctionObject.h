//
//  FunctionObject.h
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionObject : NSObject

+(id)sharedInstance;

- (NSDate *)dateFromString:(NSString *)string;
-(NSString *) dataFilePath: (NSString *) comp;
-(NSString *)stringFromDateTime: (NSDate *) date;
-(NSDate *)dateFromStringDateTime: (NSString *) dateString;
-(NSString *)stringFromDate: (NSDate *) date;
@end
