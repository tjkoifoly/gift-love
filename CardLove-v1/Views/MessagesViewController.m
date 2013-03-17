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
}

-(void) newMessageAction
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
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





@end
