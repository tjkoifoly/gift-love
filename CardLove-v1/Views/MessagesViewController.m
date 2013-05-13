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

@interface MessagesViewController ()
{
    NSMutableArray *newGroup;
}

@end

@implementation MessagesViewController

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
    return 10;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"avarta.jpg"];
    
    cell.textLabel.text = @"Nguyen Chi Cong";
    cell.detailTextLabel.text = @"foly";
    cell.badgeString = [NSString stringWithFormat:@"%i", 10];
    cell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    cell.badgeColorHighlighted = [UIColor colorWithRed:0.1 green:0.8 blue:0.219 alpha:1.000];
    cell.showShadow = YES;
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-ass2.png"]];

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:chatVC animated:YES];
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
        }else if ([newGroup count]>1)
        {
            chatVC.mode = ChatModeGroup;
            chatVC.groupMembers = newGroup;
        }
        
        [self.navigationController pushViewController:chatVC animated:YES];
        newGroup = nil;
        
    }];
}



@end
