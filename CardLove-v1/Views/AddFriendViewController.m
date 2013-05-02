//
//  AddFriendViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendCell.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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
    
    self.navigationItem.title = @"Find and add friends";
    
    _btnSelect.layer.borderWidth = 1;
    _btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    _btnSelect.layer.cornerRadius = 5;
    
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
    [self setBtnSelect:nil];
    [self setTxtFindWord:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"User name", @"Email",nil];
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :@"down"];
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
    [self resignKeyboard];
}

#pragma mark - TableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recommended Friends";
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchFriendCellIdentifier = @"SearchFriendCellIdentifier";
    SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchFriendCellIdentifier];
    
    if (!cell) {
        NSArray *arrayNib = [[NSBundle mainBundle] loadNibNamed:@"SearchFriendCell" owner:self options:nil];
        cell = [arrayNib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imvAvata.image =[UIImage imageNamed:@"emo.png"];
    [cell reloadCell];
    
    return cell;
    
}


@end
