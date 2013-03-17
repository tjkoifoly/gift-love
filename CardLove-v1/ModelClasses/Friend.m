//
//  Friend.m
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize displayName;
@synthesize userName;
@synthesize email;
@synthesize sex;
@synthesize birthday;
@synthesize address;
@synthesize phone;

-(id) initWithDictionary :(NSDictionary *) dictionary
{
    self = [super init];
    if(self)
    {
        self.displayName = [dictionary objectForKey: kDisplayName];
        self.userName = [dictionary objectForKey:kUserName];
        self.email = [dictionary objectForKey:kEmail];
        self.sex = [dictionary objectForKey:kSex];
        self.birthday = [dictionary objectForKey:kBirthday];
        self.address = [dictionary objectForKey:kAddress];
        self.phone = [dictionary objectForKey:kPhone];

    }
    return self;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.displayName forKey:kDisplayName];
    [aCoder encodeObject:self.userName forKey:kUserName];
    [aCoder encodeObject:self.email forKey:kEmail];
    [aCoder encodeObject:self.sex forKey:kSex];
    [aCoder encodeObject:self.birthday forKey:kBirthday];
    [aCoder encodeObject:self.address forKey:kAddress];
    [aCoder encodeObject:self.phone forKey:kPhone];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.displayName = [aDecoder decodeObjectForKey:kDisplayName];
        self.userName = [aDecoder decodeObjectForKey:kUserName];
        self.email = [aDecoder decodeObjectForKey:kEmail];
        self.sex = [aDecoder decodeObjectForKey:kSex];
        self.birthday = [aDecoder decodeObjectForKey:kBirthday];
        self.address = [aDecoder decodeObjectForKey:kAddress];
        self.phone = [aDecoder decodeObjectForKey:kPhone];
    }
    
    return self;
    
}









@end
