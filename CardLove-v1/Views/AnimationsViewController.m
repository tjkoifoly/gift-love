//
//  AnimationsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/1/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "AnimationsViewController.h"
#import "ThumbnailListView.h"

@interface AnimationsViewController () <ThumbnailListViewDataSource, ThumbnailListViewDelegate>

@property (strong, nonatomic) IBOutlet ThumbnailListView* thumbnailListView;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@end

@implementation AnimationsViewController

@synthesize thumbnailListView   = _thumbnailListView;
@synthesize imageView           = _imageView;

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
    
    _thumbnailListView.dataSource = self;
    _thumbnailListView.delegate = self;
    
    [_thumbnailListView reloadData];
    [_thumbnailListView selectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//=================================================================================
#pragma mark - ThumbnailListViewDataSource
//=================================================================================
- (NSInteger)numberOfItemsInThumbnailListView:(ThumbnailListView*)thumbnailListView
{
    NSLog(@"%s",__func__);
    return 10;
}

- (UIImage*)thumbnailListView:(ThumbnailListView*)thumbnailListView
				 imageAtIndex:(NSInteger)index
{
    NSLog(@"%s index:%d",__func__,index);
    UIImage* thumbnailImage = [UIImage imageNamed:[NSString stringWithFormat:@"test_%03d",index+1]];
    return thumbnailImage;
}

//=================================================================================
#pragma mark - ThumbnailListViewDelegate
//=================================================================================
- (void)thumbnailListView:(ThumbnailListView*)thumbnailListView
		 didSelectAtIndex:(NSInteger)index
{
    NSLog(@"%s index:%d",__func__,index);
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"test_%03d",index+1]];
    _imageView.image = image;
}

//=================================================================================
#pragma mark - UIScrollViewDelegate
//=================================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__func__);
    if( decelerate == NO ){
        [_thumbnailListView autoAdjustScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    [_thumbnailListView autoAdjustScroll];
}


@end
