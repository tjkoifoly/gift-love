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
    
    if (!_listGroups) {
        _listGroups = [[NSMutableArray alloc] init];
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    NSString *memberID = [[UserManager sharedInstance] accID];
    [self loadGroupsByMember:memberID completion:^(BOOL success, NSError *error) {
        [_tableView reloadData];
    }];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    
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
    [super viewDidUnload];
}

#pragma mark - TableView Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listGroups count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"ButtonAddFriend.png"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    id group = [_listGroups objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [group valueForKey:@"gmName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ member(s)",[group valueForKey:@"numbersMember"]];
    
    cell.badgeString = [NSString stringWithFormat:@"%i", 1];
    cell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    cell.badgeColorHighlighted = [UIColor colorWithRed:0.1 green:0.8 blue:0.219 alpha:1.000];
    cell.showShadow = YES;
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-ass2.png"]];

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id group = [_listGroups objectAtIndex:indexPath.row];

    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.mode = ChatModeGroup;
    //chatVC.groupMembers = newGroup;
    chatVC.group = group;
    [self.navigationController pushViewController:chatVC animated:YES];
    [newGroup removeAllObjects];
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
            
            [self createGroup:[[UserManager sharedInstance] accID] completion:^(BOOL success, NSError *error, id result) {
                
                NSDictionary *group = [result objectAtIndex:0];
               
                NSMutableString *mFriendList = [[NSMutableString alloc] init];
                for(int i = 0; i < newGroup.count; i++)
                {
                    [mFriendList appendFormat:@"%@%@", ((Friend *)[newGroup objectAtIndex:i]).fID, i==(newGroup.count -1)?@",":@""];
                }
                
                NSLog(@"LIST = %@", mFriendList);
                
                [HUD hide:YES];
                chatVC.mode = ChatModeGroup;
                chatVC.group = group;
                [self.navigationController pushViewController:chatVC animated:YES];
                [newGroup removeAllObjects];
                
            }];
            
        }
        
        
        
    }];
}

#pragma mark - Network
-(void) loadGroupsByMember: (NSString*)memberID completion:(void (^)(BOOL success, NSError *error))completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:memberID,@"memberID", nil];
    [[NKApiClient shareInstace] postPath:@"list_groups.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Groups = %@", jsonObject);
        
        [_listGroups removeAllObjects];
        for(NSDictionary *dictGroup in jsonObject)
        {
            
            [_listGroups addObject:dictGroup];
            
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



@end
