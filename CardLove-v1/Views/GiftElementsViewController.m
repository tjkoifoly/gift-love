//
//  GiftElementsViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "GiftElementsViewController.h"

@interface GiftElementsViewController ()
{
    id _selectedItem;
}
@end

@implementation GiftElementsViewController

@synthesize delegate;
@synthesize tableView = _tableView;
@synthesize dictDataSource = _dictDataSource;

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelViewController)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.title = @"Element for card";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gifElementSelected:) name:kNotificationGifSelected object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cancelViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAction
{
    if (_selectedItem) {
        [self.delegate giftElementsViewControllerDidSelected:((GifThumbnailView*)_selectedItem).imageName];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(NSMutableDictionary *) prepareDataSource
{
    _dictDataSource = [[NSMutableDictionary alloc] init];
    
    NSArray *arFlowers = [NSArray arrayWithObjects:
                          @"Flower_divider.gif",
                          @"Flower_vine.gif",
                          @"flower02.gif",
                          @"flower01.gif",
                          @"flower32.gif",
                          @"daisys.gif",
                          @"dl_flow162.gif",
                          @"flow01.gif",
                          @"flower-rose1.gif",
                          @"flower-rose02.gif",
                          @"flower03.gif",
                          @"Red_rose_opens.gif",
                          @"Red_tullips_1.gif",
                          @"Red_tullips_2.gif",
                          @"Rose_opens.gif",
                          @"roses.gif",
                          nil];
    NSArray *arXmas = [NSArray arrayWithObjects:
                       @"anixmas.gif",
                       @"xmas01.gif",
                       @"xmas02.gif",
                       @"xmas03.gif",
                       @"xmas04.gif",
                        nil];
    NSArray *hdb = [NSArray arrayWithObjects:
                    @"hbd-cake01.gif",
                    @"hbd-cake02.gif",
                    @"hbd-cake03.gif",
                    @"hbd-cake04.gif",
                    @"hbd-text01.gif",
                    @"hbd-text02.gif",
                    @"hbd-text03.gif",
                    @"hbd-text04.gif",
                    @"hbd-text05.gif",
                    @"hbd-text06.gif",nil];
    
    [_dictDataSource setObject:arFlowers forKey:@"Flowers"];
    [_dictDataSource setObject:hdb forKey:@"Happy Birthday"];
    [_dictDataSource setObject:arXmas forKey:@"XMas"];
    return _dictDataSource;
}

#pragma mark - TableView DataSource & Delegate
-(NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_dictDataSource allKeys] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [[_dictDataSource allKeys] objectAtIndex:section];
    return key;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[_dictDataSource allKeys] objectAtIndex:section];
    NSArray *arr = [_dictDataSource valueForKey:key];
    return ceil([arr count]/4.0f);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoThumbnailsCell";
    
    GifThumbnailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[GifThumbnailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger section = indexPath.section;
    NSString *key = [[_dictDataSource allKeys] objectAtIndex:section];
    NSArray *value = [_dictDataSource valueForKey:key];
    
    int startIndex = indexPath.row * 4;
    int endIndex = startIndex + 4;
    if (endIndex > [value count])
        endIndex = [value count];
    
    for (int i = startIndex; i < (startIndex+4); i++) {
       
        GifThumbnailView *gtv = [cell gifViewByTag:(i - startIndex)];
        if (i>= endIndex) {
            gtv.hidden = YES;
            continue;
        }
        NSString *imageName = [value objectAtIndex:i];
        UIImage *image = [OLImage imageNamed:imageName];

        //GifThumbnailView *gtv = [cell gifViewByTag:(endIndex - 1 - i)];
        [gtv setImage:image];
        [gtv setImageName:imageName];
        gtv.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}
#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Notification Delegate
-(void) gifElementSelected: (NSNotification *) notification
{
    GifThumbnailView *gifEle = (GifThumbnailView *) notification.object;

    if (_selectedItem) {
        [_selectedItem selected:NO];
    }
    [gifEle selected:YES];
    _selectedItem = gifEle;
    
    //View Gif
    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDictDataSource:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGifSelected object:nil];
    [super viewDidUnload];
}
@end
