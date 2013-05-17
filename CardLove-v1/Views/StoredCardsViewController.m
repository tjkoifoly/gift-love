//
//  StoredCardsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "StoredCardsViewController.h"
#import "SSCollectionView.h"
#import "SSCollectionViewItem.h"
#import "CollectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface StoredCardsViewController ()
{
    NSMutableArray *_listToEdit;
    NSMutableArray *_listItems;
}
@end

@implementation StoredCardsViewController

@synthesize listGifts = _listGifts;
@synthesize mode = _mode;
@synthesize delegate;

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
    _listGifts = [[NSMutableArray alloc] init];
    _listToEdit = [[NSMutableArray alloc] init];
    _listItems = [[NSMutableArray alloc] init];
}

-(void) viewDidUnload
{
    [self setListGifts:nil];
    _listItems = nil;
    _listToEdit = nil;
    [super viewDidUnload];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *pathProjects = [self dataFilePath:kGift];
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

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
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
    NSString *gift = [_listGifts objectAtIndex:indexPath.row];
    item.titleLabel.text = gift;
    item.imageView.image = [UIImage imageNamed:@"card-icon2.jpg"];
    
	return item;
}

- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	
    CollectionHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHeaderView" owner:self options:nil] objectAtIndex:0];
    header.lbTitle.text = [NSString stringWithFormat:@"Favorite"];
    
    return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(150, 120);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
    SSCollectionViewItem *itemSelected = [aCollectionView itemForIndexPath:indexPath];
    NSString *gift = itemSelected.titleLabel.text;
    NSString *pathProjects = [self dataFilePath:kGift];
    NSString *pathGift = [pathProjects stringByAppendingPathComponent:gift];
    
    switch (_mode) {
        case NavigationBarModeView:
        {
            [self.delegate storeCardViewControllerGiftDidSelected:pathGift];
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
        NSString *pathProjects = [self dataFilePath:kGift];
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
