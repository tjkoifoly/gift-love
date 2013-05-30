//
//  MusicViewController.m
//  CardLove-v1
//
//  Created by FOLY on 4/2/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "MusicViewController.h"

#define kNoMusic @"No Music"

@interface MusicViewController ()
{

}

@end

@implementation MusicViewController

@synthesize tableView = _tableView;
@synthesize listMusic = _listMusic;
@synthesize selectingMusic = _selectingMusic;
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
    //-----------Data-----------
    _listMusic = [NSArray arrayWithObjects:
                  @"No Music",
                  @"track1.caf",
                  @"track2.caf",
                  @"HappyBirthday.mp3",
                  @"Happynewyear.mp3",
                  @"WeWishYouAMerryChristmas.mp3",
                  nil];
    //-----------UI-----------
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMusicController)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
//    UISlider *slideVolume = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
//    slideVolume.minimumValue = 0.0;
//    slideVolume.maximumValue = 1.0f;
//    slideVolume.value = 0.5f;
//    self.navigationItem.titleView = slideVolume;
//    
//    [self setMusicVolume:slideVolume.value];
    self.navigationItem.title = @"Music for card";
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (_selectingMusic) {
        NSLog(@"Music = %@", _selectingMusic);
        [self playMusic:_selectingMusic];
    }
}

-(void) cancelMusicController
{
    [self.delegate musicViewControllerCancel];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAction
{
    [self.delegate musicViewControllerDoneActionWithMusic:_selectingMusic];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setListMusic:nil];
    [self setSelectingMusic:nil];
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark -TableView
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listMusic count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MusicCellIdentifier = @"MusicCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MusicCellIdentifier];
    }
    
    NSString *musicName = [_listMusic objectAtIndex:indexPath.row];
    cell.textLabel.text = musicName;
    if ([musicName isEqualToString:_selectingMusic]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectingMusic) {
        NSInteger index = [_listMusic indexOfObject:_selectingMusic];
        NSIndexPath *beforeIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforeIndexPath];
        beforeCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectingMusic = [_listMusic objectAtIndex:indexPath.row];
    
    [self playMusic:_selectingMusic];
}

#pragma mark -
#pragma mark - MUSIC
-(void) playMusic: (NSString *) musicName
{
    if ([musicName isEqualToString:@"No Sound"]) {
        if ([SoundManager sharedManager].isPlayingMusic) {
            [[SoundManager sharedManager] stopMusic];
        }
    }else{
        [[SoundManager sharedManager] playMusic:musicName looping:YES fadeIn:YES];
    }
    
}

-(void) setMusicVolume: (CGFloat) value
{
    [[SoundManager sharedManager] setMusicVolume:value];
}


@end
