//
//  Friend.h
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

@interface Friend : NSObject <NSCoding>

@property ( strong, nonatomic) NSString *fID;
@property (strong, nonatomic) NSString *fAvatarLink;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *phone;

-(id) initWithDictionary :(NSDictionary *) dictionary;

@end
