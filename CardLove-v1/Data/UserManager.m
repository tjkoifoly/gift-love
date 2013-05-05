//
//  UserManager.m
//  CardLove-v1
//
//  Created by FOLY on 4/30/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UserManager.h"
#import "FunctionObject.h"
#import "NKApiClient.h"
#import "AFNetworking.h"

@implementation UserManager

@synthesize displayName, username, imgAvata, password, email, birthday, phone, sex;

+(id) sharedInstance
{
    static UserManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[UserManager alloc] init];
    });
    
    return __instance;
}

-(void) updateInfoWithDictionary: (NSDictionary *) dict
{
    self.displayName = [dict valueForKey:kAccDisplayName];
    self.username = [dict valueForKey:kAccName];
    self.password = [dict valueForKey:kAccPassword];
    self.imgAvata = [dict valueForKey:kaccAvata];
    
    NSLog(@"Password = %@", self.password);
    
    self.email = [dict valueForKey: kAccEmail];
    self.phone = [dict valueForKey:kAccPhone];

    id xxx = [dict valueForKey:kAccBirthday];
    NSLog(@"Class = %@ : %@", [xxx class], xxx);
    
    NSArray *dateComponents = [[dict valueForKey :kAccBirthday ] componentsSeparatedByString:@"-"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[[dateComponents objectAtIndex:0] integerValue]];
    [components setMonth:[[dateComponents objectAtIndex:1] integerValue]];
    [components setDay:[[dateComponents objectAtIndex:2] integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    self.birthday  = [gregorian dateFromComponents:components];
    
    self.sex = [[dict valueForKey:kAccGender] boolValue];
}


@end
