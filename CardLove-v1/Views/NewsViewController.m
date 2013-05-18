//
//  NewsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "NewsViewController.h"
#import "SSCollectionView.h"
#import "SSCollectionViewItem.h"
#import "CollectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface NewsViewController ()
{
    NSDictionary *_currentGift;
}

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"News", @"News");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Gift Inbox";
    
    UIBarButtonItem *btnRefesh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refeshList:)];
    self.navigationItem.rightBarButtonItem = btnRefesh;
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    if (!_recieveArray) {
        _recieveArray = [[NSMutableArray alloc] init];
    }
    if (!_sentArray) {
        _sentArray = [[NSMutableArray alloc] init];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *userID = [[UserManager sharedInstance] accID];
    [[FunctionObject sharedInstance] loadGiftbyUser:userID completion:^(BOOL success, NSError *error, NSArray * result) {
        
        _sentArray = [[FunctionObject sharedInstance] filterGift:result bySender:userID];
        _recieveArray = [[FunctionObject sharedInstance]filterGift:result byReciver:userID];
        
        [self.collectionView reloadData];
        [HUD hide:YES];
        
    }];
    [super viewWillAppear:animated];
}

-(void) viewDidUnload
{
    [self setRecieveArray:nil];
    [self setSentArray:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 2;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
	switch (section) {
        case 0:
        {
            return [_recieveArray count];
        }
            break;
        case 1:
            return [_sentArray count];
            break;
            
        default:
            return 0;
            break;
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *const itemIdentifier = @"itemIdentifier";
    
    SSCollectionViewItem *item = [aCollectionView dequeueReusableItemWithIdentifier:itemIdentifier];
    if(!item)
    {
        item = (SSCollectionViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"SSCollectionViewItem" owner:self options:nil] objectAtIndex:0];
        item.reuseIdentifier = [itemIdentifier copy];
    }
    
    item.imageView.image = [UIImage imageNamed:@"card-icon.jpg"];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NSDictionary *dictGift;
    
    switch (section) {
        case 0:
        {
            dictGift = [_recieveArray objectAtIndex:row];
        }
            break;
        case 1:
        {
            dictGift = [_sentArray objectAtIndex:row];
        }
            break;
            
        default:
            break;
    }
    item.titleLabel.text = [dictGift valueForKey:@"gfTitle"];
    NSDate *date = [[FunctionObject sharedInstance] dateFromStringDateTime:[dictGift valueForKey:@"gfDateSent"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    item.detailTextLabel.text = [dateFormatter stringFromDate:date];
    
	return item;
}

- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
    
    CollectionHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHeaderView" owner:self options:nil] objectAtIndex:0];
    
    
    switch (section) {
        case 0:
        {
            header.lbTitle.text = @"Inbox";
        }
            break;
        case 1:
        {
            header.lbTitle.text = @"Sent";
        }
            break;
            
        default:
            break;
    }

    
    return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(150, 120);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            _currentGift = [_recieveArray objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            _currentGift = [_sentArray objectAtIndex:indexPath.row];
        }
            break;
            
        default:
            break;
    }

	NSString *title = [NSString stringWithFormat:@"You selected %@",[_currentGift valueForKey:@"gfTitle"]];
    NSString *message = [NSString stringWithFormat:@"Download and view gift"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self
										  cancelButtonTitle:@"Download" otherButtonTitles:@"Cancel", nil];
	[alert show];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 40.0f;
}

-(void) refeshList: (id) sender
{
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    switch (buttonIndex) {
        case 0:
        {
            //Download
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            NSString *pathDownload = [self pathDownload:_currentGift];
            if ([[FunctionObject sharedInstance] fileHasBeenCreatedAtPath:pathDownload]) {
                [HUD hide:YES afterDelay:0.5];
                [self performSelector:@selector(unzipAndOpenWithPath:) withObject:pathDownload afterDelay:0.5];
            }else{
                NSString *urlDownload = [_currentGift valueForKey:@"gfResourcesLink"];
                [[FunctionObject sharedInstance] dowloadFromURL:urlDownload toPath:pathDownload withProgress:^(CGFloat progress) {
                    HUD.mode = MBProgressHUDModeDeterminate;
                    HUD.progress = progress;
                } completion:^(BOOL success, NSError *error) {
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.labelText = @"Download gift successful";
                    [HUD hide:YES afterDelay:0.5];
                    [self performSelector:@selector(unzipAndOpenWithPath:) withObject:pathDownload afterDelay:0.5];

                }];

            }
            
        }
            break;
        case 1:
        {
            //cancel
        }
            break;
            
        default:
            break;
    }
     _currentGift = nil;
}

-(NSString *) pathDownload: (NSDictionary *) objGift
{
    [[FunctionObject sharedInstance] createNewFolder:kDowndloads];
    NSString *downloadFolder = [[FunctionObject sharedInstance]  dataFilePath:kDowndloads];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.zip", [objGift valueForKey:@"gfTitle"],[objGift valueForKey:@"gfID"]];
    return [downloadFolder stringByAppendingPathComponent:fileName];
}

-(void) unzipAndOpenWithPath:(NSString *)path
{
    [[FunctionObject sharedInstance] createNewFolder:kGift];
    NSString *docUnzip = [[FunctionObject sharedInstance] dataFilePath:kGift];
    
    NSString *pathUnzip = [docUnzip stringByAppendingPathComponent:[path lastPathComponent]];
    [[FunctionObject sharedInstance] unzipFileAtPath:path toPath:pathUnzip withCompetionBlock:^(NSString *pathToOpen) {
        NSLog(@"PATH = %@", pathToOpen);
        ViewGiftViewController *cvcv = [[ViewGiftViewController alloc] initWithNibName:@"ViewGiftViewController" bundle:nil];
        cvcv.giftPath = pathToOpen;
        cvcv.delegate = self;
        
        [[HMGLTransitionManager sharedTransitionManager] setTransition:[[DoorsTransition alloc] init]];
        [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:cvcv onViewController:self.navigationController];
    }];
}

#pragma mark - ViewGift Delegate
-(void) modalControllerDidFinish:(ViewGiftViewController *)modalController
{
    [[HMGLTransitionManager sharedTransitionManager] setTransition:[[DoorsTransition alloc] init]];
	[[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:modalController];
}

@end
