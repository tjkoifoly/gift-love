//
//  UserManager.h
//  CardLove-v1
//
//  Created by FOLY on 4/30/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

@interface UserManager : NSObject

@property (strong, nonatomic) NSString *accID;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *imgAvata;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *phone;
@property (nonatomic) BOOL sex;

+(id) sharedInstance;
-(void) updateInfoWithDictionary: (NSDictionary *) dict;
-(void) resetData;

@end
