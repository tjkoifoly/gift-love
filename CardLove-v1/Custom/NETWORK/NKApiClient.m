//
//  NKApiClient.m
//  NK01
//
//  Created by Cong Nguyen Chi on 1/1/13.
//  Copyright (c) 2013 BKHN. All rights reserved.
//

#import "NKApiClient.h"
#import "AFNetworking.h"

#define NKAPIBaseURLString @"http://giftlove.freevnn.com/gift-love/"
#define NKAPIToken @"1234abcd"

@implementation NKApiClient

+(id)shareInstace
{
    static NKApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[NKApiClient alloc] initWithBaseURL:[NSURL URLWithString:NKAPIBaseURLString]];
    });
    
    return __sharedInstance;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
 
    if(self)
    {
        [self setDefaultHeader:@"x-api-token" value:NKAPIToken];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];        
    }
    
    return self;
}


@end
