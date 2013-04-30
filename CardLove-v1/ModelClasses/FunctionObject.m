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

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}

@end
