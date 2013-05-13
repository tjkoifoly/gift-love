//
//  FunctionObject.m
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FunctionObject.h"

@implementation FunctionObject

+(id) sharedInstance
{
    static FunctionObject *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[FunctionObject alloc] init];
    });
    
     return __instance;
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat dateFromString:string];
}

-(NSString *)stringFromDate: (NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSString *)stringFromDateTime: (NSDate *) date
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];

    NSString *dateOput = [df_local stringFromDate:date];
    return dateOput;
}

-(NSDate *)dateFromStringDateTime: (NSString *) dateString
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
    
    NSDate *dateOput = [df_local dateFromString:dateString];
    return dateOput;
}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}




@end
