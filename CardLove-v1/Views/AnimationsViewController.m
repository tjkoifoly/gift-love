//
//  AnimationsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/1/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "AnimationsViewController.h"
#import "ThumbnailListView.h"
#import "UIEffectDesignerView.h"

@interface AnimationsViewController () <ThumbnailListViewDataSource, ThumbnailListViewDelegate>

@property (strong, nonatomic) IBOutlet ThumbnailListView* thumbnailListView;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@end

@implementation AnimationsViewController
{
    UIEffectDesignerView *_currentEffectView;
}

@synthesize thumbnailListView   = _thumbnailListView;
@synthesize imageView           = _imageView;
@synthesize listAnimations      = _listAnimations;
@synthesize currentEffect       = _currentEffect;

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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMusicController)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    _thumbnailListView.dataSource = self;
    _thumbnailListView.delegate = self;
    
    [_thumbnailListView reloadData];
    [_thumbnailListView selectAtIndex:0];
    
    //DATA
    _listAnimations = [NSArray arrayWithObjects:
                       @"blurryMayhem",
                       @"comet",
                       @"fireball",
                       @"snowfall",
                       @"soda",nil];
}

-(void) cancelMusicController
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAction
{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload
{
    [self setListAnimations: nil];
    [self setCurrentEffect:nil];
    [self setThumbnailListView:nil];
    [self setImageView:nil];
    [super  viewDidUnload];
}


//=================================================================================
#pragma mark - ThumbnailListViewDataSource
//=================================================================================
- (NSInteger)numberOfItemsInThumbnailListView:(ThumbnailListView*)thumbnailListView
{
    NSLog(@"%s",__func__);
    return [_listAnimations count];
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
