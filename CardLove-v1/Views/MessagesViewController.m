//
//  MessagesViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "MessagesViewController.h"
#import "ChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "UserManager.h"
#import "NSArray+findObject.h"
#import "GroupsManager.h"
#import "AJNotificationView.h"

@interface MessagesViewController ()
{
    NSMutableArray *newGroup;
}

@end

@implementation MessagesViewController

@synthesize listGroups = _listGroups;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnNewMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNewMessage setBackgroundImage:[UIImage imageNamed:@"New Item button.png"] forState:UIControlStateNormal];
    [btnNewMessage setFrame:CGRectMake(0, 0, 39, 34)];
    [btnNewMessage addTarget:self action:@selector(newMessageAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnNewMessage];
    
    //Listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePersonFromGroup:) name:kNotificationRemovePersonFromGroup object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPersonToGroup:) name:kNotificationAddPersonToGroup object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:kNotificationReload object:nil];
    
    _listGroups = [[GroupsManager sharedManager] listGroups];
    _listNewMsgs  = [[GroupsManager sharedManager] listMessages];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [newGroup removeAllObjects];
}

-(void) newMessageAction
{
    ModalPanelPickerView *modalPanel = [[ModalPanelPickerView alloc] initWithFrame:self.view.bounds title:@"Group Message" mode:ModalPickerFriends] ;
    [modalPanel.actionButton setTitle:@"Start" forState:UIControlStateNormal];

    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
        UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
    };
    
    ///////////////////////////////////////////
    //   Panel is a reference to the modalPanel
    modalPanel.delegate =self;
    
    [self.view addSubview:modalPanel];
	
	///////////////////////////////////
	// Show the panel from the center of the button that was pressed
	[modalPanel showFromPoint:self.view.center];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setListGroups:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationAddPersonToGroup object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRemovePersonFromGroup object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:kNotificationReload object:nil];
    [super viewDidUnload];
}

#pragma mark - TableView Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"Message Groups";
        }
            break;
        case 1:
        {
            return @"New Messages";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return [_listGroups count];
        }
            break;
        case 1:
        {
            return [_listNewMsgs count];
        }
            
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-ass2.png"]];
        
        cell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
        cell.badgeColorHighlighted = [UIColor colorWithRed:0.1 green:0.8 blue:0.219 alpha:1.000];
        cell.showShadow = YES;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            id group = [_listGroups objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"ButtonAddFriend.png"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            cell.textLabel.text = [group valueForKey:@"gmName"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ member(s)",[group valueForKey:@"numbersMember"]];
        }
            break;
        case 1:
        {
            id person = [_listNewMsgs objectAtIndex:indexPath.row];
            
            [cell.imageView setImage:[UIImage imageNamed:@"noavata.png"]];
            NSString *avatarLink = [person valueForKey:@"accImageAvata"];
            if (avatarLink!= (id)[NSNull null] && avatarLink.length != 0) {
                [cell.imageView setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"noavata.png"]];
            }
            cell.textLabel.text = [person valueForKey:@"accDisplayName"];
            cell.detailTextLabel.text = [person valueForKey:@"accName"];
            cell.badgeString = [NSString stringWithFormat:@"%@", [person valueForKey:@"newMsgs"]];

        }
            break;
            
        default:
            break;
    }
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            id group = [_listGroups objectAtIndex:indexPath.row];
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            chatVC.mode = ChatModeGroup;
            //chatVC.groupMembers = newGroup;
            chatVC.group = group;
            chatVC.delegate = self;
            [self.navigationController pushViewController:chatVC animated:YES];
            [newGroup removeAllObjects];

        }
            break;
        case 1:
        {
            NSMutableDictionary* person = [_listNewMsgs objectAtIndex:indexPath.row];
            TDBadgedCell *cell = (TDBadgedCell *)[_tableView cellForRowAtIndexPath:indexPath];
            cell.badgeString = @"0";
            [person setValue:@"0" forKey:@"newMsgs"];
            
            Friend *newFriend = [[Friend alloc] initWithDictionary:person];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            chatVC.mode = ChatModeSigle;
            chatVC.friendChatting = newFriend;
            [self.navigationController pushViewController:chatVC animated:YES];
            
//            [self readMessagesOfPerson:[person valueForKey:@"accID"] completion:^(BOOL success, NSError *error) {
//                if (success) {
//                    
//                }
//            }];
        }
            break;
            
        default:
            break;
    }
    
    }

#pragma mark - Notification
-(void) chatWithPerson: (NSNotification *) notification
{
    
    Friend *f = [notification object];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.friendChatting = f;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

-(void) addPersonToGroup: (NSNotification *) notification
{
    if (!newGroup) {
        newGroup = [[NSMutableArray alloc] init];
    }
    Friend *f = [notification object];
    [newGroup addObject:f];
}
-(void) removePersonFromGroup: (NSNotification *) notification
{
    if (!newGroup) {
        newGroup = [[NSMutableArray alloc] init];
    }
    Friend *f = [notification object];
    [newGroup removeObject:f];
}

#pragma mark - Panel Delegate
- (void)didSelectActionButton:(UAModalPanel *)modalPanel {
	UADebugLog(@"didSelectActionButton called with modalPanel: %@", modalPanel);
    [modalPanel hideWithOnComplete:^(BOOL finished) {

        ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        if ([newGroup count]==1) {
            chatVC.mode = ChatModeSigle;
            chatVC.friendChatting = [newGroup objectAtIndex:0];
            [self.navigationController pushViewController:chatVC animated:YES];
            [newGroup removeAllObjects];
        }else if ([newGroup count]>1)
        {
            //Create group
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak typeof(self) weakBlock = self;
            
            [self createGroup:[[UserManager sharedInstance] accID] completion:^(BOOL success, NSError *error, id result) {
                
                NSDictionary *group = [result objectAtIndex:0];
               
                NSMutableString *mFriendList = [[NSMutableString alloc] init];
                for(int i = 0; i < newGroup.count; i++)
                {
                    [mFriendList appendFormat:@"%@%@", ((Friend *)[newGroup objectAtIndex:i]).fID, i!=(newGroup.count -1)?@",":@""];
                }
                
                NSLog(@"LIST = %@", mFriendList);
                [self addListFriend:mFriendList toGroup:[group valueForKey:@"gmID"] completion:^(BOOL success, NSError *error) {
                    
                    [HUD hide:YES];
                    chatVC.mode = ChatModeGroup;
                    chatVC.group = group;
                    chatVC.newGroup = YES;
                    chatVC.delegate = weakBlock;
                    [weakBlock.navigationController pushViewController:chatVC animated:YES];
                }];
                
            }];
            
        }
        
    }];
}

#pragma mark - Network
-(void) loadGroupsByMember: (NSString*)memberID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:memberID,@"memberID", nil];
    [[NKApiClient shareInstace] postPath:@"list_groups.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON class = %@ and object = %@", [jsonObject class], jsonObject);
        
        _listGroups = [jsonObject objectForKey:@"groups"];
        NSArray *newPeople = [jsonObject objectForKey:@"people"];
        
        for(id dict in newPeople)
        {
            
            if([_listNewMsgs hasObjectWithKey:@"accID" andValue:[dict valueForKey:@"accID"]])
            {
                NSMutableDictionary *xxx = [_listNewMsgs findObjectWithKey:@"accID" andValue:[dict valueForKey:@"accID"]];
                [xxx setValue:[dict valueForKey:@"newMsgs"] forKey:@"newMsgs"];
            }else{
                [_listNewMsgs addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
            }
        }
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) listFriendsInGroup: (NSString*)groupID completion:(void (^)(BOOL success, NSError *error , id result))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:groupID,@"gmID", nil];
    [[NKApiClient shareInstace] postPath:@"get_friends_in_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Friends in Group = %@", jsonObject);
        
        completionBlock (YES, nil, jsonObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}

-(void) createGroup: (NSString*)userID completion:(void (^)(BOOL success, NSError *error , id result))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"creatorID", nil];
    [[NKApiClient shareInstace] postPath:@"create_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Create Group = %@", jsonObject);
        
        completionBlock (YES, nil, jsonObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}

-(void) readMessagesOfPerson:(NSString *) senderID completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[UserManager sharedInstance] accID],@"recieverID",
                                senderID,@"senderID",
                                nil];
    
    [[NKApiClient shareInstace] postPath:@"read_message.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Add friend to group = %@", jsonObject);
        
        completionBlock (YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) addFriend: (NSString*)friendID toGroup: (NSString *) groupID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"gmID",
                                friendID,@"friendID",
                                @"add", @"usage",nil];
    [[NKApiClient shareInstace] postPath:@"add_friend_to_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Add friend to group = %@", jsonObject);
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) addListFriend: (NSString*)listFriend toGroup: (NSString *) groupID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                groupID,@"gmID",
                                listFriend,@"listFriend",
                                nil];
    [[NKApiClient shareInstace] postPath:@"add_friend_to_group.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Add friend to group = %@", jsonObject);
        
        completionBlock (YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

#pragma mark - Leave Group
-(void) leaveGroup:(id)group
{
    [_listGroups removeObject:group];
    [self.tableView reloadData];
    NSString *msg = [NSString stringWithFormat:@"You has leaved from group %@!", [group valueForKey:@"gmName"]];
    [AJNotificationView showNoticeInView:self.navigationController.view type:AJNotificationTypeOrange title:msg hideAfter:2.5f];
    
    
}



@end
