//
//  FriendInfoViewController.m
//  CardLove-v1
//
//  Created by FOLY on 5/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "FriendInfoCell.h"
#import "UIViewController+NibCells.h"

@interface FriendInfoViewController ()

@end

@implementation FriendInfoViewController

@synthesize currentFriend = _currentFriend;

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
    
    if (_currentFriend) {
        self.navigationItem.title = _currentFriend.displayName;
    }
}
-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCurrentFriend:nil];
    [super viewDidUnload];
}

#pragma mark - Table View

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
            
        case 1:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"Information";
        }
            break;
            
        case 1:
        {
            return @"Special days";
        }
            break;
        default:
            break;
    }
    return nil;

}

-(FriendInfoCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FriendInfoCellIdentifier = @"FriendInfoCell";
    FriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendInfoCellIdentifier];
    if (!cell) {
        
        cell = (FriendInfoCell *)[self loadReusableTableViewCellFromNibNamed:@"FriendInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row==0) {
                cell.lbTitle.text = @"User";
                cell.lbContent.text = _currentFriend.userName;
            }else if(row == 1)
            {
                cell.lbTitle.text = @"Email";
                cell.lbContent.text = _currentFriend.email;
            }else if (row ==2 )
            {
                cell.lbTitle.text = @"Gender";
                cell.lbContent.text = _currentFriend.sex;
            }else if (row == 3)
            {
                cell.lbTitle.text = @"Phone";
                cell.lbContent.text = _currentFriend.phone;
            }
        }
            break;
        case 1:
        {
            if (row == 0) {
                cell.lbTitle.text = @"Birthday";
                cell.lbContent.text = _currentFriend.birthday;
            }
        }
            break;
            
        default:
            break;
    }

    
    return cell;
}




@end
