//
//  Friend.m
//  CardLove-v1
//
//  Created by FOLY on 3/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize fID;
@synthesize fAvatarLink;
@synthesize displayName;
@synthesize userName;
@synthesize email;
@synthesize sex;
@synthesize birthday;
@synthesize phone;

-(id) initWithDictionary :(NSDictionary *) dictionary
{
    self = [super init];
    if(self)
    {
        self.fID = [dictionary objectForKey:kAccID] ;
        self.fAvatarLink = [dictionary objectForKey:kaccAvata];
        self.displayName = [dictionary objectForKey: kAccDisplayName];
        self.userName = [dictionary objectForKey:kAccName];
        self.email = [dictionary objectForKey:kAccEmail];
        self.sex = [dictionary objectForKey:kAccGender];
        self.birthday = [dictionary objectForKey:kAccBirthday];
        self.phone = [dictionary objectForKey:kAccPhone];

    }
    return self;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fID forKey:kAccID];
    [aCoder encodeObject:self.fAvatarLink forKey:kaccAvata];
    [aCoder encodeObject:self.displayName forKey:kAccDisplayName];
    [aCoder encodeObject:self.userName forKey:kAccName];
    [aCoder encodeObject:self.email forKey:kAccEmail];
    [aCoder encodeObject:self.sex forKey:kAccGender];
    [aCoder encodeObject:self.birthday forKey:kAccBirthday];
    [aCoder encodeObject:self.phone forKey:kAccPhone];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.displayName = [aDecoder decodeObjectForKey:kAccDisplayName];
        self.userName = [aDecoder decodeObjectForKey:kAccName];
        self.email = [aDecoder decodeObjectForKey:kAccEmail];
        self.sex = [aDecoder decodeObjectForKey:kAccGender];
        self.birthday = [aDecoder decodeObjectForKey:kAccBirthday];
        self.phone = [aDecoder decodeObjectForKey:kAccPhone];
        self.fID = [aDecoder decodeObjectForKey:kAccID];
        self.fAvatarLink = [aDecoder decodeObjectForKey:kaccAvata];
    }
    
    return self;
    
}









@end
