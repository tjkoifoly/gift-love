//
//  RequestsManager.m
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "RequestsManager.h"
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "AJNotificationView.h"
#import "NSArray+findObject.h"

@implementation RequestsManager

+(id)sharedManager
{
    static RequestsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[RequestsManager alloc] init];
    });
    
    return __instance;
}

-(id) init
{
    if(self = [super init])
    {
        if (!_listRequests) {
            _listRequests = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void) resetData
{
    [_listRequests removeAllObjects];
}

-(void) loadRequest: (NSString*)userID completion:(CompletionBlockWithResult)completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID", nil];
    [[NKApiClient shareInstace] postPath:@"get_friend_requests.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON REQUEST = %@", jsonObject);
        
        
        NSMutableArray *mATemp = [[NSMutableArray alloc] init];
        
        for(id dict in jsonObject)
        {
            if ([_listRequests hasObjectWithKey:@"accID" andValue:[dict valueForKey:@"accID"]]) {
                continue;
            }else
            {
                [mATemp addObject: dict];
                
            }
        }
        
        [_listRequests addObjectsFromArray:mATemp];
        if ([mATemp count] > 0) {
            NSString *msg = @"";
            
            if ([mATemp count] == 1) {
                msg = [NSString stringWithFormat:@"%@ requests friend to you !", [[mATemp objectAtIndex:0] valueForKey:@"accName"]];
            }else{
                msg = [NSString stringWithFormat: @"%i person(s) request friend with you!", [mATemp count]];
            }
            [AJNotificationView showNoticeInView:self.viewContainer
                                            type:AJNotificationTypeBlue
                                           title:msg
                                 linedBackground:AJLinedBackgroundTypeAnimated
                                       hideAfter:2.5f
                                        response:^{
                                            //This block is called when user taps in the notification
                                            NSLog(@"Response block");
                                        }
             ];
        }
        mATemp = nil;
        
        completionBlock (YES, nil, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}

@end
