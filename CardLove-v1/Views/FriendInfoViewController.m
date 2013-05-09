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
#import "EGOImageView.h"
#import "FunctionObject.h"
#import "BButton.h"
#import <QuartzCore/QuartzCore.h>
#import "NKApiClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "UserManager.h"

#define kbHeightPortrait 254.000000

@interface FriendInfoViewController ()
{
    BOOL keyboardIsOn;
}

@end

@implementation FriendInfoViewController

@synthesize currentFriend = _currentFriend;
@synthesize specials = _specials;
@synthesize keyboardToolbar = _keyboardToolbar;
@synthesize monthViewCalendar = _monthViewCalendar;

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
    
    if (!self.specials) {
        self.specials = [[NSMutableArray alloc] init];
    }
    
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;

        UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(doneKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:cancelBarItem, spaceBarItem, doneBarItem, nil]];
        
    }
    
    if(_monthViewCalendar == nil)
    {
        _monthViewCalendar = [[TKCalendarMonthView alloc] initWithSundayAsFirst:NO];
        _monthViewCalendar.delegate  = self;
        _monthViewCalendar.dataSource = self;
        //NSLog(@"MONTH %f x %f", monthViewCalendar.bounds.size.width, monthViewCalendar.bounds.size.height);
        [_monthViewCalendar reload];
    }

    keyboardIsOn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *userID = [[UserManager sharedInstance] accID];
    NSDictionary*dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"sourceID",
                               _currentFriend.fID, @"friendID",
                               nil];
    [self loadResultWithParams:dictParams];

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
    [self setKeyboardToolbar:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewDidUnload];
}

-(void) loadResultWithParams: (NSDictionary *)dictParams
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [[NKApiClient shareInstace] postPath:@"list_special_days.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *jsonArray = [[JSONDecoder decoder] objectWithData:responseObject];
        [self.specials addObjectsFromArray:jsonArray];
        NSLog(@"JSON Friend = %@", _specials);
        [self.tableView reloadData];
        
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        NSLog(@"HTTP ERROR = %@", error);
        
    }];
}


#pragma mark - Load View
-(void) loadSpecialsDayWith: (NSString *)sourceID andFriend: (NSString *) friendID
{
    
}


#pragma mark - Table View

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 5;
        }
            break;
            
        case 1:
        {
            return 1 + [_specials count];
        }
            break;
            
        case 2:
            return 1;
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0) {
        return 90;
    }else
    {
        return 46;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 2) {
        UITableViewCell *addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCellIdentifier"];
        
        BButton *btnAddDay = [[BButton alloc] initWithFrame:CGRectMake(7.5f, 0, 305, 46) type:BButtonTypeSuccess];
        [btnAddDay setTitle:@"Add a special day" forState:UIControlStateNormal];
        [btnAddDay addAwesomeIcon:FAIconCalendar beforeTitle:YES];
        [btnAddDay addTarget:self action:@selector(addSpecialDay:) forControlEvents:UIControlEventTouchUpInside];
        [addCell addSubview:btnAddDay];
        
        return addCell;
    }else if (section == 0 && row == 0)
    {
        UITableViewCell *firstCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FirstCellFI"];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_note.png"]];
        
        EGOImageView *imvAvatar = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"DefaultImageGrid.png"]];
        imvAvatar.frame = CGRectMake(20, 5, 80, 80);
        
        //                CGFloat x = cell.center.x;
        //                CGPoint centerPoint = CGPointMake(x, 45);
        //                imvAvatar.center = centerPoint;
        
        imvAvatar.layer.borderWidth = 3.0f;
        imvAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        imvAvatar.layer.cornerRadius= 5.0f;
        imvAvatar.layer.masksToBounds = YES;
        
        [firstCell addSubview:imvAvatar];
        
        if (_currentFriend.fAvatarLink != (id)[NSNull null] && _currentFriend.fAvatarLink.length != 0) {
            imvAvatar.imageURL = [NSURL URLWithString:_currentFriend.fAvatarLink];
        }
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 189, 21)];
        lbName.center = CGPointMake(206, 22);
        UIFont *font = [UIFont fontWithName:@"Cochin" size:18];
        [lbName setFont:font];
        lbName.text = _currentFriend.displayName;
        lbName.backgroundColor = [UIColor clearColor];
        [firstCell addSubview:lbName];
        
        UILabel *lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 189, 21)];
        lbStatus.center = CGPointMake(206, 52);
        [lbStatus setFont:font];
        lbStatus.text = _currentFriend.displayName;
        lbStatus.backgroundColor = [UIColor clearColor];
        [firstCell addSubview:lbStatus];

        switch ([_currentFriend.fStatus intValue]) {
            case FriendRequest:
            {
                lbStatus.textColor = [UIColor darkGrayColor];
                lbStatus.text = @"Friend requesting";
            }
                break;
            case FriendSuccessful:
            {
                lbStatus.textColor = [UIColor greenColor];
                lbStatus.text = @"Friend OK";
            }
                break;
                
            default:
                break;
        }

        return firstCell;
        
    }
    
    static NSString *FriendInfoCellIdentifier = @"FriendInfoCell";
    FriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendInfoCellIdentifier];
    if (!cell) {
        
        cell = (FriendInfoCell *)[self loadReusableTableViewCellFromNibNamed:@"FriendInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.btnDelete.hidden = YES;
    cell.txtTitle.hidden = YES;
    cell.txtContent.hidden = YES;
   
    switch (section) {
        case 0:
        {
            if (row==1) {
                cell.lbTitle.text = @"Username";
                cell.lbContent.text = _currentFriend.userName;
            }else if(row == 2)
            {
                cell.lbTitle.text = @"Email";
                cell.lbContent.text = _currentFriend.email;
            }else if (row ==3 )
            {
                cell.lbTitle.text = @"Gender";
                cell.lbContent.text = [_currentFriend.sex isEqualToString:@"0"]? @"male":@"female";
            }else if (row == 4)
            {
                cell.lbTitle.text = @"Phone";
                cell.lbContent.text = _currentFriend.phone != (id)[NSNull null]?_currentFriend.phone:@"";
            }
        }
            break;
            
        case 1:
        {
            if (row == 0) {
                cell.lbTitle.text = @"Birthday";
                cell.lbContent.text = _currentFriend.birthday;
            }else
            {
                
                id currentObject = [_specials objectAtIndex:row-1];
                //NSLog(@"Current = %@", currentObject);
                cell.lbTitle.text = [currentObject valueForKey:kSpecialDayTitle];
                cell.lbContent.text = [currentObject valueForKey:kSpecialDayDate];
                
//                cell.lbTitle.hidden = YES;
//                cell.lbContent.hidden = YES;
//                
//                cell.txtTitle.hidden = NO;
//                cell.txtContent.hidden = NO;
                
                cell.txtTitle.tag = 2*row;
                cell.txtContent.tag = 2*row + 1;
                
                cell.txtTitle.inputAccessoryView = self.keyboardToolbar;
                cell.txtContent.inputAccessoryView = self.keyboardToolbar;
                cell.txtContent.inputView = self.monthViewCalendar;
                
                cell.delegate = self;
                cell.btnDelete.hidden = NO;
            }
        }
            break;

        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }

    
    return cell;
}

-(void) addSpecialDay: (id) sender
{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"",kSpecialDayTitle,
                                 @"", kSpecialDayDate, nil];
    [self.specials addObject:dict];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_tableView numberOfRowsInSection:1]) inSection:1];

    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    FriendInfoCell *cell = (FriendInfoCell *)[_tableView cellForRowAtIndexPath:lastIndexPath];
    
    cell.lbTitle.hidden = YES;
    cell.lbContent.hidden = YES;
    
    cell.txtTitle.hidden = NO;
    cell.txtContent.hidden = NO;

    [cell.txtTitle becomeFirstResponder];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void) modifyDaysWithParams: (NSDictionary *) params  completion:(void (^)(BOOL success, NSError *error, NSString *result))completionBlock
{
    [[NKApiClient shareInstace] postPath:@"add_special_day.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * jsonObject = [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"RESULT = %@", jsonObject);
        completionBlock(YES, nil, [jsonObject objectAtIndex:0]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR : %@", error);
         completionBlock(NO, nil, @"");
    }];

}

-(void) friendInfoCellOnDelete:(FriendInfoCell *)cell
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[UserManager sharedInstance] accID],@"sourceID",
                            _currentFriend.fID, @"friendID",
                            @"delete_day", @"usage",
                            cell.lbTitle.text, kSpecialDayTitle,
                            cell.lbContent.text, kSpecialDayDate,
                            nil];
    [self modifyDaysWithParams:params completion:^(BOOL success, NSError *error, NSString * result) {
        if ([result isEqualToString:@"Success"]) {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            NSInteger indexSpecial = indexPath.row-1;
            [self.specials removeObjectAtIndex:indexSpecial];
            
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        
        NSUInteger tag = [firstResponder tag];
        UIBarButtonItem *item = [[[self keyboardToolbar] items] lastObject];
        if (tag%2 == 0) {
            [item setTitle:@"Next"];
        }else{
            [item setTitle:@"Done"];

        }
        
    }

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGFloat moveHeight = kbSize.height + self.tableView.frame.origin.y;
        
        [self view:self.tableView move:-moveHeight];
        
    } completion:^(BOOL finished) {
        keyboardIsOn = YES;
        
    }];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"KBSIZE = %f", kbSize.height);
    
    [UIView animateWithDuration:0.2f animations:^{
        
       [self view:self.tableView move:kbSize.height];
        
    } completion:^(BOOL finished) {
        keyboardIsOn = NO;
    }];
}

-(void) view: (UIView *)v move: (CGFloat) height
{
    CGRect frame = v.frame;
    frame.origin.y += height;
    [v setFrame:frame];
}

-(void) resignKeyboard: (id) sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        
    }
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([_tableView numberOfRowsInSection:1] - 1) inSection:1];
    [self deleteRowAtPath:lastIndexPath];
}

-(void) deleteRowAtPath: (NSIndexPath *) indexPath
{
    NSInteger indexSpecial = indexPath.row-1;
    [self.specials removeObjectAtIndex:indexSpecial];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (id)getFirstResponder
{
    NSUInteger index = 2;
    while (index <= (2 * self.specials.count+1)) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

-(void) doneKeyboard: (id) sender
{
    UIBarButtonItem *item = [[[self keyboardToolbar] items] lastObject];
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        
        if ([((UITextField *)firstResponder).text isEqualToString:@""]) {
            [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"All fields not empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
            
        }
        NSUInteger tag = [firstResponder tag];
        if (tag%2 == 0) {
            NSUInteger nextTag = tag+1;
            UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
            [nextField becomeFirstResponder];
            
            [item setTitle:@"Done"];
            NSDate *today = [NSDate date];
            nextField.text = [[FunctionObject sharedInstance] stringFromDate:today];
            
        }else
        {
            
            
            UITextField *endField = (UITextField *)firstResponder;
            NSUInteger prevTag = tag-1;
            UITextField *prevField = (UITextField *)[self.view viewWithTag:prevTag];
            
            NSString *title = prevField.text;
            NSString *content= endField.text;
            
            if ([((UITextField *)prevField).text isEqualToString:@""]) {
                [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Title field not empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                return;
            }

            NSUInteger indexCell = prevTag/2;
            NSMutableDictionary *dict = [_specials objectAtIndex:indexCell-1];
            NSString *oldKey = [[dict allKeys]objectAtIndex:0];
            [dict removeObjectForKey:oldKey];
            
            NSDate *date = [[FunctionObject sharedInstance] dateFromString:content];
            [dict setValue:date forKey:title];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCell inSection:1];
            FriendInfoCell *cell = (FriendInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            
            cell.lbTitle.text = title;
            cell.lbContent.text = content;
            
            cell.lbTitle.hidden = NO;
            cell.lbContent.hidden = NO;
            
            NSMutableDictionary *mDict = [_specials objectAtIndex:indexPath.row-1];
            [mDict setValue:title forKey:kSpecialDayTitle];
            [mDict setValue:content forKey:kSpecialDayDate];
            
            prevField.hidden = YES;
            endField.hidden = YES;
            
            [firstResponder resignFirstResponder];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [[UserManager sharedInstance] accID],@"sourceID",
                                    _currentFriend.fID, @"friendID",
                                    @"add_day", @"usage",
                                    title, kSpecialDayTitle,
                                    content, kSpecialDayDate,
                                    nil];
            [self modifyDaysWithParams:params completion:^(BOOL success, NSError *error, NSString *result) {
                if (![result isEqualToString:@"Success"]) {
                    [self deleteRowAtPath:indexPath];
                }
            }];
        }
    }
}

#pragma mark - Month View Delegate


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}

-(void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)date
{
    NSLog(@"%@", date);
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        ((UITextField *)firstResponder).text = [[FunctionObject sharedInstance] stringFromDate:date];
    }
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated
{
    
}


@end
