//
//  CardsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "CardsViewController.h"
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"
#import "UIView+Positioning.h"

#import "SSCollectionView.h"
#import "SSCollectionViewItem.h"
#import "CollectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>


@interface CardsViewController ()
{
    SSCollectionViewItem *currentItem;
}
-(void)addStandardTabView;
-(void)addCustomTabView;
@end

@implementation CardsViewController

@synthesize listGifts =_listGifts;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Cards", @"Cards");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    _listGifts = [[NSMutableArray alloc] init];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *pathProjects = [self dataFilePath:kProjects];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *subDirs = [fileMgr contentsOfDirectoryAtPath:pathProjects error:&error];
    
    _listGifts = [NSMutableArray arrayWithArray:subDirs];
    
    [self.collectionView reloadData];

}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}

-(void) viewDidUnload
{
    [self setListGifts:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods
-(void)addStandardTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60.)] ;
    
    [tabView setDelegate:self];
    
    [tabView addTabItemWithTitle:@"One" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
    
    //    You can run blocks by specifiying an executeBlock: paremeter
    //    #if NS_BLOCKS_AVAILABLE
    //    [tabView addTabItemWithTitle:@"One" icon:nil executeBlock:^{NSLog(@"abc");}];
    //    #endif
    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
}

-(void)addCustomTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.)] ;
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [tabView setDelegate:self];
    
    UIImage * standardIcon = [UIImage imageNamed:@"icon3.png"];
    UIImage * highlightedIcon = [UIImage imageNamed:@"icon2.png"];
    
    UIImage *imgCenter = [UIImage imageNamed:@"imagetbButtonSubmit.png"];
    
    CustomTabItem * tabItem1 = [CustomTabItem tabItemWithTitle:@"Frame" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem2 = [CustomTabItem tabItemWithTitle:@"Edit" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem3 = [CustomTabItem tabItemWithTitle:@"" icon:imgCenter alternateIcon:imgCenter];
    CustomTabItem * tabItem4 = [CustomTabItem tabItemWithTitle:@"Text" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem5 = [CustomTabItem tabItemWithTitle:@"Effect" icon:standardIcon alternateIcon:highlightedIcon];

    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
    [tabView addTabItem:tabItem3];
    [tabView addTabItem:tabItem4];
    [tabView addTabItem:tabItem5];
    
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:1.];
    [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] init] ];
    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
}


-(void)loadView;
{
    CustomNoiseBackgroundView * noiseBackgroundView = [[CustomNoiseBackgroundView alloc] init] ;
    self.view = noiseBackgroundView;
    
    //[self addStandardTabView];
    //[self addCustomTabView];

}


#pragma mark - TabView Delegate
-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
	return [_listGifts count];
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *const itemIdentifier = @"itemIdentifier";
    
    //    SSCollectionViewItem *item  = (SSCollectionViewItem *)[aCollectionView dequeueReusableItemWithIdentifier:itemIdentifier];
    //	if(!item)
    //    {
    //        item = [[SSCollectionViewItem alloc] initWithStyle:SSCollectionViewItemStyleSubtitle reuseIdentifier:itemIdentifier];
    //
    //
    //        item.layer.borderColor = [UIColor blackColor].CGColor;
    //        item.layer.borderWidth = 2.0f;
    //        item.layer.cornerRadius = 10.0f;
    //
    //        item.layer.masksToBounds = NO;
    //        item.layer.shadowColor = [UIColor blackColor].CGColor;
    //        item.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    //        item.layer.shadowOpacity = 1.0f;
    //        item.layer.shadowRadius = 4.5f;
    //        item.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.bounds].CGPath;
    //
    //    }
    //
    //    item.textLabel.frame  = CGRectMake(90, 36, 66, 21);
    //    item.textLabel.text = @"FOLY MEN";
    //    item.textLabel.backgroundColor = [UIColor clearColor];
    //
    //    item.imageView.frame = CGRectMake(10, 10, 60, 80);
    //    item.imageView.image = [UIImage imageNamed:@"list-item-cover-men1.png"];
    //
    //    item.imageView.layer.masksToBounds = NO;
    //    item.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    item.imageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    //    item.imageView.layer.shadowOpacity = 1.0f;
    //    item.imageView.layer.shadowRadius = 4.5f;
    //    item.imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.imageView.bounds].CGPath;
    
    SSCollectionViewItem *item = [aCollectionView dequeueReusableItemWithIdentifier:itemIdentifier];
    if(!item)
    {
        item = (SSCollectionViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"SSCollectionViewItem" owner:self options:nil] objectAtIndex:0];
        item.reuseIdentifier = [itemIdentifier copy];
    }
    id gift = [_listGifts objectAtIndex:indexPath.row];
    NSLog(@"Gift object = %@", gift);
    item.titleLabel.text = [NSString stringWithFormat:@"%@", gift ];
    
	return item;
}

- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	
    //    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    //	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //	header.text = [NSString stringWithFormat:@"Section %i", section + 1];
    //	header.shadowColor = [UIColor whiteColor];
    //	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
    //	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
	//return header;
    
    CollectionHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHeaderView" owner:self options:nil] objectAtIndex:0];
    header.lbTitle.text = [NSString stringWithFormat:@"Section %i", section + 1];
    
    return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(150, 120);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *title = [NSString stringWithFormat:@"You selected item %i in section %i!",
					   indexPath.row + 1, indexPath.section + 1];

    NSLog(@"%@",title);
    
    SSCollectionViewItem *itemSelected = [aCollectionView itemForIndexPath:indexPath];
    [self selectItem:itemSelected];
}

-(void) selectItem: (SSCollectionViewItem *)itemSelected
{
    [currentItem setBackgroundColor:[UIColor clearColor]];
    currentItem = itemSelected;
    [itemSelected setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    NSString *gift = itemSelected.titleLabel.text;
    
    [self.delegate cardViewControllerDidSelected:gift];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 40.0f;
}




@end
