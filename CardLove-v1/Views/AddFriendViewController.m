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

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
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
    
}

-(void) doneAction
{
    NSLog(@"Done");
    [self backPreviousView];
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
    [_txtFindWord resignFirstResponder];
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
    [self resignKeyboard];
}

-(void) loadResultWithParams: (NSDictionary *)dictParams
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [[NKApiClient shareInstace] postPath:@"find_friends.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.result = [[JSONDecoder decoder] objectWithData:responseObject];
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
    cell.imvAvata.image =[UIImage imageNamed:@"noavata.png"];
    cell.lbName.text = [person valueForKey:kAccName];
    
    return cell;
    
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
    
}

-(void) cancelFriendRequest: (NSNotification *) notification
{
    NSLog(@"Object = %@", notification.object);
    SearchFriendCell *cell = (SearchFriendCell *) notification.object;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    
    id object = [_result objectAtIndex:row];
    NSLog(@"Cancel to : %@",object);
}

@end
