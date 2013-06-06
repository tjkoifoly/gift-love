//
//  GroupsManager.m
//  CardLove-v1
//
//  Created by FOLY on 5/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GroupsManager.h"
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "AJNotificationView.h"
#import "NSArray+findObject.h"

@implementation GroupsManager

+(id)sharedManager
{
    static GroupsManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[GroupsManager alloc] init];
    });
    
    return __instance;
}

-(id) init
{
    if(self = [super init])
    {
        if (!_listGroups) {
            _listGroups = [[NSMutableArray alloc] init];
        }
        if (!_listMessages) {
            _listMessages = [[NSMutableArray alloc] init];
        }
        _firstLoad = YES;
    }
    return self;
}

-(void) resetData
{
    [_listGroups removeAllObjects];
    [_listMessages removeAllObjects];
    _firstLoad = YES;
}

-(void) loadGroupsByMember: (NSString*)memberID completion:(CompletionBlockWithResult)completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:memberID,@"memberID", nil];
    [[NKApiClient shareInstace] postPath:@"list_groups.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        //NSLog(@"JSON class = %@ and object = %@", [jsonObject class], jsonObject);
        
        NSMutableArray *listGroups = [jsonObject objectForKey:@"groups"];
        for(id gDict in listGroups)
        {
            if([_listGroups hasObjectWithKey:@"gmID" andValue:[gDict valueForKey:@"gmID"]])
            {
                continue;
            }else{
                [_listGroups addObject:[NSMutableDictionary dictionaryWithDictionary:gDict]];
                
                if (_firstLoad) {
                    
                }else{
                    NSString *msg = [NSString stringWithFormat:@"You has been invited to join new group %@!", [gDict valueForKey:@"gmName"]];
                    
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
            }

        }//END FOR
        
        
        NSArray *newPeople = [jsonObject objectForKey:@"people"];
        
        for(id dict in newPeople)
        {
            if([_listMessages hasObjectWithKey:@"accID" andValue:[dict valueForKey:@"accID"]])
            {
                NSMutableDictionary *xxx = [_listMessages findObjectWithKey:@"accID" andValue:[dict valueForKey:@"accID"]];
                
                int numOld = [[xxx valueForKey:@"newMsgs"] intValue];
                int numNew = [[dict valueForKey:@"newMsgs"] intValue];
                [xxx setValue:[dict valueForKey:@"newMsgs"] forKey:@"newMsgs"];
                if (numOld < numNew) {
                    NSString *msg = [NSString stringWithFormat:@"%i new message(s) from %@",(numNew-numOld) ,[dict valueForKey:@"accName"]];
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
                
                
            }else{
                [_listMessages addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
                
                if (!_firstLoad) {
                    NSString *msg = [NSString stringWithFormat:@"%i new message(s) from %@", [[dict valueForKey:@"newMsgs"] intValue],[dict valueForKey:@"accName"]];
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
                
            }
        }
        
        _firstLoad = NO;
        completionBlock (YES, nil, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}




@end
