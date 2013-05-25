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
    NSMutableArray *_listToEdit;
    NSMutableArray *_listItems;
}

-(void)addStandardTabView;
-(void)addCustomTabView;
@end

@implementation CardsViewController

@synthesize listGifts =_listGifts;
@synthesize mode = _mode;
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
    _mode = NavigationBarModeView;
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    _listGifts = [[NSMutableArray alloc] init];
    _listToEdit = [[NSMutableArray alloc] init];
    _listItems = [[NSMutableArray alloc] init];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSString *pathProjects = [self dataFilePath:kProjects];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *subDirs = [fileMgr contentsOfDirectoryAtPath:pathProjects error:&error];
    
    _listGifts = [NSMutableArray arrayWithArray:subDirs];
    if ([_listGifts count] >0) {
        if ([[_listGifts objectAtIndex:0] isEqual:@".DS_Store"]) {
            [_listGifts removeObjectAtIndex:0];
        }
    }
    
    [self.collectionView reloadData];
    [_listItems removeAllObjects];
    [_listToEdit removeAllObjects];

    [super viewDidAppear:animated];
    
    
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
    _listToEdit = nil;
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
    
    SSCollectionViewItem *item = [aCollectionView dequeueReusableItemWithIdentifier:itemIdentifier];
    if(!item)
    {
        item = (SSCollectionViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"SSCollectionViewItem" owner:self options:nil] objectAtIndex:0];
        item.reuseIdentifier = [itemIdentifier copy];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:item.frame];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.image = [UIImage imageNamed:@"mask.png"];
        [item setSelectedBackgroundView:backgroundView];
        
        UILabel *selected = [[UILabel alloc] initWithFrame:CGRectMake(2, cellHeight-textLabelHeight-2, cellWidth-4   , textLabelHeight)];
        selected.tag = tagSelected;
        selected.backgroundColor = [UIColor darkGrayColor];
        selected.textColor = [UIColor whiteColor];
        selected.text = @"DELETE";
        selected.textAlignment = NSTextAlignmentCenter;
        selected.font = [UIFont systemFontOfSize:defaultFontSize];
        
        [item addSubview:selected];
    }
    
    [[item viewWithTag:tagSelected] setAlpha:cellAHidden];
    [item setSelected:NO];
    id gift = [_listGifts objectAtIndex:indexPath.row];
    if ([_listToEdit containsObject:gift]) {
        [item setSelected:YES];
        [[item viewWithTag:tagSelected] setAlpha:cellAAcitve];
    }else{
        [item setSelected:NO];
        [[item viewWithTag:tagSelected] setAlpha:cellAHidden];
    }
    NSLog(@"Gift object = %@", gift);
    item.titleLabel.text = [NSString stringWithFormat:@"%@", gift ];
    item.imageView.image = [UIImage imageNamed:@"card-icon.jpg"];
    
	return item;
}

- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
    
    CollectionHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHeaderView" owner:self options:nil] objectAtIndex:0];
    header.lbTitle.text = [NSString stringWithFormat:@"Favorite"];
    
    return nil;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(cellWidth, cellHeight);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *title = [NSString stringWithFormat:@"You selected item %i in section %i!",
					   indexPath.row + 1, indexPath.section + 1];

    NSLog(@"%@",title);
    
    SSCollectionViewItem *itemSelected = [aCollectionView itemForIndexPath:indexPath];
    NSString *gift = itemSelected.titleLabel.text;
    NSString *pathProjects = [self dataFilePath:kProjects];
    NSString *pathGift = [pathProjects stringByAppendingPathComponent:gift];
    
    switch (_mode) {
        case NavigationBarModeView:
        {
            
            [self.delegate cardViewControllerDidSelected:pathGift];
        }
            break;
            
        case NavigationBarModeEdit:
        {
            if (itemSelected.isSelected) {
                [itemSelected setSelected:NO];
                [[itemSelected viewWithTag:tagSelected] setAlpha:cellAHidden];
                
                if ([_listItems containsObject:indexPath]) {
                    [_listItems removeObject:indexPath];
                }
                
                if ([_listToEdit containsObject:gift]) {
                    [_listToEdit removeObject:gift];
                }
            }else{
                [itemSelected setSelected:YES];
                [[itemSelected viewWithTag:tagSelected] setAlpha:cellAAcitve];
                
                if (![_listItems containsObject:indexPath]) {
                    [_listItems addObject:indexPath];
                }
                
                if (![_listToEdit containsObject:gift]) {
                    [_listToEdit addObject:gift];
                }
            }
            
            NSLog(@"Edit = %@", _listToEdit);
            
        }
            break;
        default:
            break;
    }
   
}

-(void) collectionView:(SSCollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 40.0f;
}

-(void) editDone
{
    if ([_listToEdit count] == 0) {
        return;
    }
    
    for(NSString *gift in _listToEdit)
    {
        NSString *pathProjects = [self dataFilePath:kProjects];
        NSString *pathGift = [pathProjects stringByAppendingPathComponent:gift];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:pathGift error:&error];
        if (error) {
            NSLog(@"ERROR delete directory = %@", error);
        }else
        {
            NSLog(@"Deleted gift %@ successful .", [pathGift lastPathComponent]);
        }
    }
    
    [self.collectionView deleteItemsAtIndexPaths:_listItems withItemAnimation:SSCollectionViewItemAnimationRight];
    
    
    [_listGifts removeObjectsInArray:_listToEdit];
    [_listToEdit removeAllObjects];
    [_listItems removeAllObjects];

    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    
}

-(void) reloadData
{
    [self.collectionView reloadData];
     [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You have just deleted some gifts" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
}



@end
