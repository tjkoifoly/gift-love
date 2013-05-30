//
//  BGPickerViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/13/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "BGPickerViewController.h"

@interface BGPickerViewController ()

@end

@implementation BGPickerViewController

@synthesize type = _type;
@synthesize dataSource = _dataSource;
@synthesize dictParent = _dictParent;

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
    // Give us a nice title
    self.title = @"BG Picker";
    
    // Create a reload button
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    // setup the page control
    [self setupPageControl];
    
    if ([_type isEqualToString:kGiftBG]) {
        [self loadBGs];
    }else if ([_type isEqualToString:kGiftFrame])
    {
        [self loadFrames];
    }else if ([_type isEqualToString:kGiftPaper])
    {
        [self loadPapers];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setGridView:nil];
    [self setPageControl:nil];
    [self setType:nil];
    [self setDataSource:nil];
    [super viewDidUnload];
}

- (void)reload
{
    [_gridView reloadData];
}


- (void)setupPageControl
{
    _pageControl.numberOfPages = _gridView.numberOfPages;
    _pageControl.currentPage = _gridView.currentPageIndex;
}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadPapers
{
    _dataSource = [NSArray arrayWithObjects:
                   @"Gift_Paper_Habitat_1.png" ,
                   @"Gift_Paper_Habitat_2.png" ,
                   @"bg-sc-1.png" ,
                   @"bg-sc-2.png" ,
                   nil];
}

-(void) loadBGs
{
    _dataSource = [NSArray arrayWithObjects:
                   @"cover-01.png" ,
                   @"cover-02.png" ,
                   @"cover-03.png" ,
                   @"cover-04.png" ,
                   nil];
}

-(void) loadFrames
{
    _dataSource = [NSArray arrayWithObjects:
                   @"card-frame-4.png" ,
                   @"card-frame-1.png" ,
                   @"card-frame-2.png" ,
                   @"card-frame-3.png" ,
                   @"card-frame-5.png" ,
                   nil];
}

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [_dataSource count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull];
    NSString *imgName = [_dataSource objectAtIndex:index];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",imgName];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    //cell.imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-none.png"]];
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    return cell;

}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    NSLog(@"OK");
    
    NSString *imgName = [_dataSource objectAtIndex:index];
    [_dictParent setValue:imgName forKey:_type];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"Cell at index %d was double tapped.", index]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cool!"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    [self setupPageControl];
}



@end
