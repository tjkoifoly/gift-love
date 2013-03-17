//
//  EventsManagerViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/15/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "EventsManagerViewController.h"
#import "DetailEventViewController.h"
#import "CreateAEventViewController.h"

@interface EventsManagerViewController ()

@end

@implementation EventsManagerViewController

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
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    self.navigationItem.rightBarButtonItem = btnAdd;
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

-(void) addEvent
{
    CreateAEventViewController *lrvc = [[CreateAEventViewController alloc] initWithNibName:@"CreateAEventViewController" bundle:nil];
    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:lrvc] animated:YES];
}


#pragma mark - UITableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EventCellIdentifier = @"EventCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:EventCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Event %i", indexPath.row ];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailEventViewController *vrvc = [[DetailEventViewController alloc] initWithNibName:@"DetailEventViewController" bundle:nil];
    [self.navigationController pushViewController:vrvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
