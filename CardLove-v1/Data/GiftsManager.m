//
//  GiftsManager.m
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftsManager.h"
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "FunctionObject.h"
#import "AJNotificationView.h"
#import "NSArray+findObject.h"

@implementation GiftsManager

+(id)sharedManager
{
    static GiftsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[GiftsManager alloc] init];
    });
    
    return __instance;
}

-(id) init
{
    if(self = [super init])
    {
        if (!_listSentGifts) {
            _listSentGifts = [[NSMutableArray alloc] init];
        }
        if (!_listRecievedGifts) {
            _listRecievedGifts = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void) resetData
{
    [_listSentGifts removeAllObjects];
    [_listRecievedGifts removeAllObjects];
}

-(void) loadGiftbyUser: (NSString*)userID completion:(CompletionBlockWithResult) completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID", nil];
    [[NKApiClient shareInstace] postPath:@"get_gift.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON Gift LIST = %@", jsonObject);
        
        NSMutableArray *listSent = [[FunctionObject sharedInstance] filterGift:jsonObject bySender:userID];
        for(id dict in listSent)
        {
            if (![_listSentGifts hasObjectWithKey:@"gfID" andValue:[dict valueForKey:@"gfID"]]) {
                [_listSentGifts addObject:dict];
            }
        }
        
        NSInteger numNew = 0;
        
        NSMutableArray * _listRecieved = [[FunctionObject sharedInstance]filterGift:jsonObject byReciver:userID];
        NSMutableArray *temAddObjects = [[NSMutableArray alloc] init];
        for(id dict in _listRecieved)
        {
            if ([_listRecievedGifts hasObjectWithKey:@"gfID" andValue:[dict valueForKey:@"gfID"]]) {
                NSMutableDictionary *xxx = [_listRecievedGifts findObjectWithKey:@"gfID" andValue:[dict valueForKey:@"gfID"]];
                [xxx setValue:[dict valueForKey:@"gfMarkOpened"] forKey:@"gfMarkOpened"];
                
            }else if([[dict valueForKey:@"gfMarkOpened"] intValue] == 1)
            {
                [temAddObjects addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
            }else
            {
                [_listRecievedGifts insertObject:[NSMutableDictionary dictionaryWithDictionary:dict] atIndex:0 ];
                numNew++;
            }
        }
    
        if ([temAddObjects count] > 0) {
            [_listRecievedGifts addObjectsFromArray:temAddObjects];
        }
        temAddObjects = nil;
        
        if(numNew >  0)
        {
            NSString *msg = [NSString stringWithFormat:@"You recieved %i new gift(s) !", numNew];
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
        
        completionBlock (YES, nil, [NSNumber numberWithInteger:numNew]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}

@end
