//
//  AddFriendViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendCell.h"
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "UserManager.h"
#import "ChatViewController.h"
#import "RequestsManager.h"
#import "NSArray+findObject.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController
{
    id currentObject;
    SearchFriendCell *currentCell;
}

@synthesize result  = _result;

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
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    self.navigationItem.title = @"Add friends";
    
//    _btnSelect.layer.borderWidth = 1;
//    _btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
//    _btnSelect.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFriendRequest:) name:kNotificationSendFriendRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFriendRequest:) name:kNotificationCancelFriendRequest object:nil];
    
    if (!_result) {
        _result = [[NSMutableArray alloc] init];
    }
    
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary*dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"finderID", nil];
    [self loadResultWithParams:dictParams];
    
    if (pullRefreshView == nil) {
		
        pullRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		pullRefreshView.delegate = self;
		[self.tableView addSubview:pullRefreshView];
	}
	
	//  update the last update date
	[pullRefreshView refreshLastUpdatedDate];
    
}

-(void) doneAction
{
    NSLog(@"Done");
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary*dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"finderID", nil];
    [self loadResultWithParams:dictParams];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setResult:nil];
    [self setBtnSelect:nil];
    [self setTxtFindWord:nil];
    [self setTableView:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:kNotificationCancelFriendRequest object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:kNotificationSendFriendRequest object:nil];

    [self setViewBack:nil];
    [self setImvBack:nil];
    [self setImvTxtBack:nil];
    [self setBtnSearch:nil];
    [super viewDidUnload];
}

- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"username", @"email",nil];
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :@"up"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSLog(@"Title = %@", _btnSelect.titleLabel.text);
    [self rel];
}

-(void)rel{
    dropDown = nil;
}

-(IBAction) resignKeyboard
{
    [self find:self.btnSearch];
   
}
- (IBAction)find:(id)sender {
    
    NSString *titleSearch = _btnSelect.titleLabel.text;
    NSString *contentSearch = _txtFindWord.text;
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary*dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"finderID",
                               contentSearch, titleSearch,
                               nil];
    
    [self loadResultWithParams:dictParams];
    [_txtFindWord resignFirstResponder];
}

-(void) refreshDataWithBlock:(void(^)())completionBlock
{
    NSString *titleSearch = _btnSelect.titleLabel.text;
    NSString *contentSearch = _txtFindWord.text;
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary*dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"finderID",
                               contentSearch, titleSearch,
                               nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [[NKApiClient shareInstace] postPath:@"find_friends.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *listFound = [[JSONDecoder decoder] objectWithData:responseObject];
        self.result = [NSMutableArray arrayWithArray:listFound];
        NSLog(@"JSON Friend = %@", _result);
        [self.tableView reloadData];
        [hud hide:YES];
        
        completionBlock();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        NSLog(@"HTTP ERROR = %@", error);
        
    }];

}

-(void) loadResultWithParams: (NSDictionary *)dictParams
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [[NKApiClient shareInstace] postPath:@"find_friends.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *listFound = [[JSONDecoder decoder] objectWithData:responseObject];
        self.result = [NSMutableArray arrayWithArray:listFound];
        NSLog(@"JSON Friend = %@", _result);
        [self.tableView reloadData];
        
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [hud hide:YES];
        NSLog(@"HTTP ERROR = %@", error);
        
    }];
}

#pragma mark - TableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_result count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchFriendCellIdentifier = @"SearchFriendCell";
    SearchFriendCell *cell = (SearchFriendCell *)[tableView dequeueReusableCellWithIdentifier:SearchFriendCellIdentifier];
    
    if (!cell) {
//        NSArray *arrayNib = [[NSBundle mainBundle] loadNibNamed:@"SearchFriendCell" owner:self options:nil];
//        cell = [arrayNib objectAtIndex:0];
        cell = (SearchFriendCell *)[self loadReusableTableViewCellFromNibNamed:@"SearchFriendCell"];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"init cell %@",  [cell reuseIdentifier]);
    }
    
    id person = [_result objectAtIndex:indexPath.row];
    NSString *name = [person valueForKey:kAccName];
    cell.lbName.text = name;
    
    Friend *obj = [[FriendsManager sharedManager] friendByName:name];
    NSLog(@"STATUS = %@", obj.fStatus);
    
    if (!obj) {
        [cell.btnFriend changeToState:NO];
        cell.btnFriend.hidden = NO;
        UIView *imv = [cell viewWithTag:999];
        if (imv) {
            imv.hidden = YES;
        }
        
    }else{
        
        switch ([obj.fStatus intValue]) {
            case FriendRequest:
            {
                [cell.btnFriend changeToState:YES];
                cell.btnFriend.hidden = NO;
                UIView *imv = [cell viewWithTag:999];
                if (imv) {
                    imv.hidden = YES;
                }
                
            }
                break;
            case FriendSuccessful:
            {
                [cell becomFriend];
            }
                break;
                
            default:
                break;
        }
    }
    
    NSString *avatarLink = [person valueForKey:kaccAvata];
    if (avatarLink!= (id)[NSNull null] && avatarLink.length != 0) {
        [cell setPhoto:avatarLink];
    }

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id person = [_result objectAtIndex:indexPath.row];
    Friend *tempFriend = [[Friend alloc] initWithDictionary:person];
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.friendChatting = tempFriend;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self view:self.btnSearch move:-kbSize.height];
        [self view:self.btnSelect move:-kbSize.height];
        [self view:self.txtFindWord move:-kbSize.height];
        [self view:self.imvBack move:-kbSize.height];
        [self view:self.imvTxtBack move:-kbSize.height];
        [self view:self.viewBack move:-kbSize.height];
        
    } completion:^(BOOL finished) {

        
    }];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self view:self.btnSearch move:kbSize.height];
        [self view:self.btnSelect move:kbSize.height];
        [self view:self.txtFindWord move:kbSize.height];
        [self view:self.imvBack move:kbSize.height];
        [self view:self.imvTxtBack move:kbSize.height];
        [self view:self.viewBack move:kbSize.height];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) view: (UIView *)v move: (CGFloat) height
{
    CGRect frame = v.frame;
    frame.origin.y += height;
    [v setFrame:frame];
}

-(void) sendFriendRequest: (NSNotification *) notification
{
    NSLog(@"Object = %@", notification.object);
    SearchFriendCell *cell = (SearchFriendCell *) notification.object;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    
    id object = [_result objectAtIndex:row];
    NSLog(@"Send to : %@",object);
    
    NSMutableArray *arrRequests = [[RequestsManager sharedManager] listRequests];
    if (![arrRequests hasObjectWithKey:kAccID andValue:[object valueForKey:kAccID]]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[UserManager sharedInstance] accID],@"sourceID",
                                [object valueForKey:kAccID], @"friendID",
                                @"send_request", @"usage",
                                nil];
        
        [[NKApiClient shareInstace] postPath:@"add_friend.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            id jsonObject = [[JSONDecoder decoder] objectWithData:responseObject];
            NSLog(@"%@", jsonObject);
            NSString *userID = [[UserManager sharedInstance] accID];
            [[FriendsManager sharedManager] loadFriendsFromURLbyUser: userID completion:^(BOOL success, NSError *error) {
                
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"HTTP ERROR : %@", error);
        }];
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Do you want to accept?" message:@"This account sent a friend request to you." delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Accept", nil] show];
        currentObject = object;
        currentCell = cell;
    }  
    
}

-(void) cancelFriendRequest: (NSNotification *) notification
{
    NSLog(@"Object = %@", notification.object);
    SearchFriendCell *cell = (SearchFriendCell *) notification.object;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    
    id object = [_result objectAtIndex:row];
    NSLog(@"Cancel to : %@",object);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[UserManager sharedInstance] accID],@"sourceID",
                            [object valueForKey:kAccID], @"friendID",
                            @"cancel_request", @"usage",
                            nil];
    
    [[NKApiClient shareInstace] postPath:@"add_friend.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject = [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"%@", jsonObject);
        NSString *userID = [[UserManager sharedInstance] accID];
        [[FriendsManager sharedManager] loadFriendsFromURLbyUser: userID completion:^(BOOL success, NSError *error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR : %@", error);
    }];
}

#pragma mark - AlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"ACCEPT REQUEST to %@", currentObject);
        
        [[FunctionObject sharedInstance] responeRequestWithUser:[[UserManager sharedInstance] accID] person:[currentObject valueForKey:@"accID"] preRelationship:@"0" andState:[NSString stringWithFormat:@"%i", 2] completion:^(BOOL success, NSError *error) {
            [self.result removeObject:currentObject];
            [self.tableView reloadData];
            
            NSMutableArray *maRequsts = [[RequestsManager sharedManager] listRequests];
            id xxx = [maRequsts findObjectWithKey:kAccID andValue:[currentObject valueForKey:kAccID]];
            [maRequsts removeObject:xxx];
            
            currentCell = nil;
            currentObject = nil;
        }];
    }else
    {
        [currentCell.btnFriend changeToState:NO];
        currentCell = nil;
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	isLoading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	isLoading = NO;
	[pullRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[pullRefreshView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [self refreshDataWithBlock:^{
        [self doneLoadingTableViewData];
    }];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
