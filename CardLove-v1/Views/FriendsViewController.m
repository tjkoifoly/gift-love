//
//  FriendsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendsViewController.h"
#import "DrawerViewMenu.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "EKNotifView.h"
#import "AddFriendViewController.h"

#import "ModalPanelPickerView.h"
#import "UANoisyGradientBackground.h"
#import "UAGradientBackground.h"
#import "UserManager.h"

#import "FriendInfoViewController.h"

typedef void (^FinishBlock)();

@interface FriendsViewController ()
{
    NSIndexPath *currentIndexPath;
}
@end

@implementation FriendsViewController

@synthesize tableView           = _tableView;
@synthesize actionHeaderView    = _actionHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Friends", @"Friends");
        self.tabBarItem.image = [UIImage imageNamed:@"friends.png"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    [self loadActionHeaderView];
    
    //    UIButton *btnAddFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnAddFriend setBackgroundImage:[UIImage imageNamed:@"ButtonAddFriend.png"] forState:UIControlStateNormal];
    //    btnAddFriend.frame = CGRectMake(0, 0, 40, 30);
    //    [btnAddFriend addTarget:self action:@selector(addFriendView) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddFriend];
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendView)];
    self.navigationItem.rightBarButtonItem = btnAdd;
}

-(void) viewDidAppear:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [[FriendsManager sharedManager] loadFriends];
    NSString *userID = [[UserManager sharedInstance] accID];
    [[FriendsManager sharedManager] loadFriendsFromURLbyUser:userID completion:^(BOOL success, NSError *error) {
        [hud hide:YES];
    }];
    [_tableView reloadData];
    [super viewDidAppear:animated];
}

-(void) addFriendView
{
//    Friend *f = [[Friend alloc] init];
//    f.displayName = @"Nguyen Chi Cong";
//    f.userName = @"foly";
//    
//    [[FriendsManager sharedManager] addFriend:f];
//    [[FriendsManager sharedManager]loadFriends];
//    
//    NSIndexPath *newLastIndexPath = [NSIndexPath indexPathForRow:([_tableView numberOfRowsInSection:(_tableView.numberOfSections - 1)]) inSection:(_tableView.numberOfSections - 1)];
//    //[_tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
//    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newLastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [self performSelector:@selector(addFriendCompleteWithBlock:) withObject:^{
//        [_tableView reloadData];
//        } afterDelay:0.5];
    
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] initWithNibName:@"AddFriendViewController" bundle:nil];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//
//-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Friends List";
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[FriendsManager sharedManager] friendsList] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    
    HHPanningTableViewCell *cell = (HHPanningTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[HHPanningTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        DrawerViewMenu *drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerViewMenu" owner:nil options:nil] objectAtIndex:0];
        drawerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
        drawerView.delegate = self;
        
        cell.drawerView = drawerView;
    }
    
    //cell.delegate = self;
    cell.directionMask = HHPanningTableViewCellDirectionLeft;
    
    ((DrawerViewMenu *)cell.drawerView).indexPath = indexPath;
    
    Friend *cF = [[[FriendsManager sharedManager] friendsList] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cF.displayName;
    cell.detailTextLabel.text = cF.userName;
    cell.imageView.image = [UIImage imageNamed:@"avarta.jpg"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.badgeString = [NSString stringWithFormat:@"%i", 2];
    
    cell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    cell.showShadow = YES;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([cell isKindOfClass:[HHPanningTableViewCell class]]) {
		HHPanningTableViewCell *panningTableViewCell = (HHPanningTableViewCell*)cell;
		
		if ([panningTableViewCell isDrawerRevealed]) {
			return nil;
		}
	}
	
	return indexPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"LOG = %@", [[[[FriendsManager sharedManager] friendsList] objectAtIndex:indexPath.row] displayName]);
    
    Friend *f = [[[FriendsManager sharedManager] friendsList] objectAtIndex:indexPath.row];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.friendChatting = f;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - ActionHeader

-(void) itemAction:(id)sender
{
    self.actionHeaderView.titleLabel.text = @"Contacts List";
    [self.actionHeaderView shrinkActionPicker];
}

-(void) loadActionHeaderView
{
    self.actionHeaderView = [[DDActionHeaderView alloc] initWithFrame:self.view.bounds];
    self.actionHeaderView.titleLabel.text = @"Friends List";
    
    UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainButton addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainButton setImage:[UIImage imageNamed:@"mainButton"] forState:UIControlStateNormal];
    mainButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    mainButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    mainButton.center = CGPointMake(25.0f, 25.0f);
    
    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsButton addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    [friendsButton setImage:[UIImage imageNamed:@"friend-button"] forState:UIControlStateNormal];
    friendsButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    friendsButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    friendsButton.center = CGPointMake(75.0f, 25.0f);
    
    UIButton *contactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactsButton addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    [contactsButton setImage:[UIImage imageNamed:@"ContactsList"] forState:UIControlStateNormal];
    contactsButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    contactsButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    contactsButton.center = CGPointMake(125.0f, 25.0f);
	
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.items = [NSArray arrayWithObjects:mainButton, friendsButton, contactsButton, nil];
	
    [self.view addSubview:self.actionHeaderView];
}


#pragma mark -
#pragma mark HHPanningTableViewCellDelegate

- (void)panningTableViewCellDidTrigger:(HHPanningTableViewCell *)cell inDirection:(HHPanningTableViewCellDirection)direction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Action"
                                                    message:@"You triggered a custom action"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - DrawMenu Delegate
-(void) updateContact:(NSIndexPath *)indexPath
{
    NSLog(@"Update %@", indexPath);
    FriendInfoViewController *fivc = [[FriendInfoViewController alloc] initWithNibName:@"FriendInfoViewController" bundle:nil];
    
    fivc.currentFriend =  [[[FriendsManager sharedManager] friendsList] objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:fivc animated:YES];
}

-(void) sendMessageTo:(NSIndexPath *)indexPath
{
    NSLog(@"Chat %@", indexPath);
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void) sendGiftTo:(NSIndexPath *)indexPath
{
//    NSLog(@"Gift %@", indexPath);
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSArray *controllers = [appDelegate.menuController _controllers];
//        [appDelegate.revealController setContentViewController: controllers[1][3]];
//    NSIndexPath *indexPathMenu = [NSIndexPath indexPathForRow:3 inSection:1];
//    [appDelegate.menuController._menuTableView selectRowAtIndexPath:indexPathMenu animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    ModalPanelPickerView *modalPanel = [[ModalPanelPickerView alloc] initWithFrame:self.view.bounds title:@"Choose a gift" mode:ModalPickerGifts] ;
    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
        UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
    };
    
    ///////////////////////////////////////////
    //   Panel is a reference to the modalPanel
    modalPanel.onActionPressed = ^(UAModalPanel* panel) {
        UADebugLog(@"onActionPressed block called from panel: %@", modalPanel);
    };

    modalPanel.delegate = self;
    
    [self.view addSubview:modalPanel];
	
	///////////////////////////////////
	// Show the panel from the center of the button that was pressed
	[modalPanel showFromPoint:self.view.center];
    
}

-(void) removeContact:(NSIndexPath *)indexPath
{
    NSLog(@"Remove %@", indexPath);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete this contact" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    currentIndexPath = indexPath;
}

#pragma mark - ActionSheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"Delete");
            [[FriendsManager sharedManager] removeFriendAtIndex:currentIndexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
           
            [self performSelector:@selector(deleteContactCompleteWithBlock:) withObject:^{
                    [self.tableView reloadData];
                } afterDelay:0.5];
            
            currentIndexPath = nil;
            
            break;
        }
        case 1:
        {
            NSLog(@"Cancel");
            currentIndexPath = nil;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - AlertAction

-(void) deleteContactCompleteWithBlock: (FinishBlock) reloadBlock
{
    EKNotifView *note = [[EKNotifView alloc] initWithNotifViewType:EKNotifViewTypeSuccess notifPosition:EKNotifViewPositionBottom notifTextStyle:EKNotifViewTextStyleTitle andParentView:self.view];
    [note changeTitleOfLabel:EKNotifViewLabelTypeTitle to:@"Unfriend successful !"];
    [note show];
    
    reloadBlock();
}

-(void) addFriendCompleteWithBlock: (FinishBlock) reloadBlock
{
    EKNotifView *note = [[EKNotifView alloc] initWithNotifViewType:EKNotifViewTypeSuccess notifPosition:EKNotifViewPositionBottom notifTextStyle:EKNotifViewTextStyleTitle andParentView:self.view];
    [note changeTitleOfLabel:EKNotifViewLabelTypeTitle to:@"Added a friend successful !"];
    [note show];
    
    reloadBlock();
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setActionHeaderView:nil];
    [super viewDidUnload];
}

#pragma mark - UAModalDisplayPanelViewDelegate

// Optional: This is called before the open animations.
//   Only used if delegate is set.
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the open animations.
//   Only used if delegate is set.
- (void)didShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called when the close button is pressed
//   You can use it to perform validations
//   Return YES to close the panel, otherwise NO
//   Only used if delegate is set.
- (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
	return YES;
}

// Optional: This is called when the action button is pressed
//   Action button is only visible when its title is non-nil;
//   Only used if delegate is set and not using blocks.
- (void)didSelectActionButton:(UAModalPanel *)modalPanel {
	UADebugLog(@"didSelectActionButton called with modalPanel: %@", modalPanel);
}

// Optional: This is called before the close animations.
//   Only used if delegate is set.
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
}

@end
