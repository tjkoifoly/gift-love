//
//  ViewGiftViewController.m
//  CardLove-v1
//
//  Created by FOLY on 3/18/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ViewGiftViewController.h"
#import "SoundManager.h"
#import "HMSideMenu.h"

@interface ViewGiftViewController ()

@property (nonatomic, strong) HMSideMenu *sideMenu;
@end

@implementation ViewGiftViewController

@synthesize giftPath = _giftPath;
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
    //Sound Manager
    [SoundManager sharedManager].allowsBackgroundMusic = NO;
    [[SoundManager sharedManager] prepareToPlay];
    
    self.viewCard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cover-01.png"]];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Update View
    if (!_preview) {
        [self performSelector:@selector(loadMenu) withObject:nil afterDelay:1];
    }
    
    [self loadGiftByPath:_giftPath];
    [self loadConfigurationWithPath:_giftPath];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        _imvOverlay.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        [_imvOverlay removeFromSuperview];
//    }];
}

-(void) backPreviousView
{
    if ([[SoundManager sharedManager] isPlayingMusic]) {
        [[SoundManager sharedManager] stopMusic];
    }
    [self.delegate modalControllerDidFinish:self];
}

-(void) loadMenu
{
    UIView *emailItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [emailItem setMenuActionWithBlock:^{
        NSLog(@"tapped email item");
    }];
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30 , 30)];
    [emailIcon setImage:[UIImage imageNamed:@"mn-mail.png"]];
    [emailItem addSubview:emailIcon];
    
    UIView *giftItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [giftItem setMenuActionWithBlock:^{
        NSLog(@"tapped gift item");
        ModalPanelPickerView *modalPanel = [[ModalPanelPickerView alloc] initWithFrame:self.view.bounds title:@"Choose a friend" mode:ModalPickerFriendsToSend] ;
        modalPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            [panel hideWithOnComplete:^(BOOL finished) {
                [panel removeFromSuperview];
                NSLog(@"CURRENT = nil");
            }];
            UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        
        ///////////////////////////////////////////
        //   Panel is a reference to the modalPanel
        modalPanel.onActionPressed = ^(UAModalPanel* panel) {
            UADebugLog(@"onActionPressed block called from panel: %@", modalPanel);
        };
        
        [self.view addSubview:modalPanel];
        
        ///////////////////////////////////
        // Show the panel from the center of the button that was pressed
        [modalPanel showFromPoint:self.view.center];
    }];
    UIImageView *giftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30 , 30)];
    [giftIcon setImage:[UIImage imageNamed:@"mn-gift.png"]];
    [giftItem addSubview:giftIcon];
    
    UIView *chatItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [chatItem setMenuActionWithBlock:^{
        // EDIT
        
    }];
    UIImageView *chatIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30 , 30)];
    [chatIcon setImage:[UIImage imageNamed:@"mg-chat.png"]];
    [chatItem addSubview:chatIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[emailItem, giftItem, chatItem]];
    [self.sideMenu setItemSpacing:5.0f];
    self.sideMenu.menuPosition = HMSideMenuPositionBottom;
    [self.view addSubview:self.sideMenu];
    [self.sideMenu open];
}

-(void) loadGiftByPath: (NSString *) pathOfGift
{
    [self loadGiftView];
    [self loadGiftLabels];
    [self loadGIFElement];
    [self loadMusic];
    [self loadAnimation];
}

-(void) viewDidUnload
{
    [self setGiftPath:nil];
    [self setViewGift:nil];
    [self setViewCard:nil];
    [self setImvFrameCard:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)closeViewGiftController:(id)sender {
    [self backPreviousView];
}

#pragma mark - LOAD GIFT ITEMS
-(void) addViewPhotoWithItem: (GiftItem *) item
{
    GestureView *imvPhoto = [[GestureView alloc] initWithType:GestureViewToView];
    UIImage *image = [UIImage imageWithContentsOfFile:item.photo];
    
    imvPhoto.bounds = CGRectFromString(item.bounds);
    imvPhoto.center = CGPointFromString(item.center);
    imvPhoto.transform = CGAffineTransformFromString(item.transform);
    imvPhoto.imgURL = item.photo;
        [imvPhoto addLayersWithImage:image];
    //imvPhoto.delegate = self;
    imvPhoto.shadowLayer.borderWidth = [item.borderWidth floatValue];
    imvPhoto.shadowLayer.cornerRadius  = [item.borderRadius floatValue];
    imvPhoto.photoLayer.cornerRadius = [item.borderRadius floatValue];
    imvPhoto.shadowLayer.opacity = [item.borderOpacity floatValue];
    
    NSArray *colorRGB = [item.borderColor componentsSeparatedByString:@" "];
    
    if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceRGBColorSpace"]) {
        UIColor *colorText = [UIColor colorWithRed:[[colorRGB objectAtIndex:1] floatValue] green:[[colorRGB objectAtIndex:2] floatValue] blue:[[colorRGB objectAtIndex:3] floatValue] alpha:[[colorRGB objectAtIndex:4] floatValue]];
        imvPhoto.shadowLayer.borderColor = colorText.CGColor;
    }else if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceWhiteColorSpace"])
    {
        UIColor *colorText = [UIColor colorWithWhite:[[colorRGB objectAtIndex:1] floatValue] alpha:[[colorRGB objectAtIndex:2] floatValue]];
        imvPhoto.shadowLayer.borderColor = colorText.CGColor;
    }
    
    
    imvPhoto.shadowLayer.shadowOffset = CGSizeFromString(item.shadowOffset);
    imvPhoto.shadowLayer.shadowOpacity = [item.shadowOpacity floatValue];
    imvPhoto.shadowLayer.shadowRadius = [item.shadowRadius floatValue];
    
    colorRGB = [item.shadowColor componentsSeparatedByString:@" "];
    
    if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceRGBColorSpace"]) {
        UIColor *colorText = [UIColor colorWithRed:[[colorRGB objectAtIndex:1] floatValue] green:[[colorRGB objectAtIndex:2] floatValue] blue:[[colorRGB objectAtIndex:3] floatValue] alpha:[[colorRGB objectAtIndex:4] floatValue]];
        imvPhoto.shadowLayer.shadowColor = colorText.CGColor;
    }else if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceWhiteColorSpace"])
    {
        UIColor *colorText = [UIColor colorWithWhite:[[colorRGB objectAtIndex:1] floatValue] alpha:[[colorRGB objectAtIndex:2] floatValue]];
        imvPhoto.shadowLayer.shadowColor = colorText.CGColor;
    }

    
    [self.viewCard addSubview:imvPhoto];
}

-(void) loadGiftView
{
    NSString *pathItems = [_giftPath stringByAppendingPathComponent:kIndex];
    [[GiftItemManager sharedManager] setPathData:pathItems];
    NSArray *listItems = [[GiftItemManager sharedManager] getListItems];
    NSLog(@"LIST = %@", listItems);
    
    for(GiftItem *gi in listItems)
    {
        [self addViewPhotoWithItem:gi];
    }
}

#pragma mark - LOAD GIFT LABELS

-(void) loadGiftLabels
{
    NSString *pathLabels = [_giftPath stringByAppendingPathComponent:[NSString stringWithFormat:kGiftLabel]];
    NSLog(@"PATH Label = %@", pathLabels);
    [[GiftLabelsManager sharedManager] setPathData:pathLabels];
    
    NSArray *listLabels = [[GiftLabelsManager sharedManager] getListLabels];
    
    for(GiftLabel *gl in listLabels)
    {
        //Add label to view
        [self addGestureLabelWithGiftLabel:gl];
    }
}

-(void) addGestureLabelWithGiftLabel: (GiftLabel *) gLabel
{
    if (!gLabel) {
        return;
    }
    
    GestureLabel * labelText = [[GestureLabel alloc] initWithType:GestureLabelToView];
    labelText.backgroundColor = [UIColor clearColor];
    
    labelText.labelID = gLabel.labelID;
    labelText.bounds = CGRectFromString(gLabel.bounds);
    labelText.center = CGPointFromString(gLabel.center);
    labelText.transform = CGAffineTransformFromString(gLabel.transform);
    //labelText.delegate = self;
    
    labelText.text = gLabel.text;
    labelText.font = [UIFont fontWithName:gLabel.fontName size:[gLabel.fontSize floatValue]];
    
    NSArray *colorRGB = [gLabel.textColor componentsSeparatedByString:@" "];
    
    if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceRGBColorSpace"]) {
        UIColor *colorText = [UIColor colorWithRed:[[colorRGB objectAtIndex:1] floatValue] green:[[colorRGB objectAtIndex:2] floatValue] blue:[[colorRGB objectAtIndex:3] floatValue] alpha:[[colorRGB objectAtIndex:4] floatValue]];
        labelText.textColor = colorText;
    }else if ([[colorRGB objectAtIndex:0] isEqual:@"UIDeviceWhiteColorSpace"])
    {
        UIColor *colorText = [UIColor colorWithWhite:[[colorRGB objectAtIndex:1] floatValue] alpha:[[colorRGB objectAtIndex:2] floatValue]];
        labelText.textColor = colorText;
    }
    [labelText setNumberOfLines:0];
    
    [self.viewCard addSubview:labelText];
    
}

#pragma mark -LOAD GIFT ELEMENTS

-(void) loadGIFElement
{
    NSString *pathElements = [_giftPath stringByAppendingPathComponent:[NSString stringWithFormat:kElements]];
    [[GiftElementsManager sharedManager] setPathData:pathElements];
    NSArray *listElements = [[GiftElementsManager sharedManager] getListElements];
    NSLog(@"LIST = %@", listElements);
    
    for(GiftElement *gi in listElements)
    {
        [self addPhotoViewWithItem:gi];
    }
}

-(void) addPhotoViewWithItem: (GiftElement *) item
{
    UIImage *image = [OLImage imageNamed:item.imageURL];
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image withType:GestureImageViewToView];
    imvPhoto.bounds = CGRectFromString(item.bounds);
    imvPhoto.center = CGPointFromString(item.center);
    imvPhoto.transform = CGAffineTransformFromString(item.transform);
    imvPhoto.imgURL = item.imageURL;
    imvPhoto.elementID = item.elementID;
    //imvPhoto.delegate = self;
    [self.viewCard addSubview:imvPhoto];
    
}


#pragma mark - LOAD GIFT MUSIC

-(void) loadMusic
{
    NSString *pathMusic = [_giftPath stringByAppendingPathComponent:kMusic];
    NSError *error;
    NSString *currentMusic = [NSString stringWithContentsOfFile:pathMusic encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"MUSIC = %@", currentMusic);
    
    if (![currentMusic isEqualToString:@""]) {
        [self playMusic:currentMusic];
    }
}

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

#pragma mark - LOAD GIFT ANIMATION

-(void) loadAnimation
{
    NSString *pathAnimation = [_giftPath stringByAppendingPathComponent:kAnimation];
    NSError *error;
    NSString *strCurrentEffect = [NSString stringWithContentsOfFile:pathAnimation encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"ANIMATION = %@", strCurrentEffect);
    
    if ((strCurrentEffect != nil) && (![kNoEff isEqualToString: strCurrentEffect])) {
        UIEffectDesignerView *currentEffect = [UIEffectDesignerView effectWithFile:strCurrentEffect];
        [self.imvFrameCard addSubview:currentEffect];
    }
}

#pragma mark - ZIP
-(NSString *) saveAsZip
{
    NSString *projectPath = _giftPath;
    NSString *giftName = [_giftPath lastPathComponent];
    NSString *docspath = [[FunctionObject sharedInstance] dataFilePath:kPackages];
    
    NSString *zipFile = [docspath stringByAppendingPathComponent:giftName];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    //[za addDirectoryToZip:projectPath];
    NSArray *filesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:projectPath error:NULL];
    NSMutableArray *mutFiles = [NSMutableArray arrayWithArray:filesInDirectory];
    
    for(id file in mutFiles)
    {
        NSLog(@"Adding file = %@ ...", file);
        [za addFileToZip:[projectPath stringByAppendingPathComponent:file] newname:file];
    }
    
    BOOL success = [za CloseZipFile2];
    
    NSLog(@"Zipped file with result %d",success);
    NSLog(@"Zip Path = %@", zipFile);
    
    return zipFile;
}

#pragma mark - LOAD ConfigGift
-(void) loadConfigurationWithPath: (NSString *)path
{
    NSString *filePath = [path stringByAppendingPathComponent:kConfig];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSString *strTemp = [dict valueForKey:kGiftPaper];
    UIImage *imgTemp = [UIImage imageNamed:strTemp];
    self.view.backgroundColor = [UIColor colorWithPatternImage:imgTemp];
    
    strTemp = [dict valueForKey:kGiftBG];
    imgTemp = [UIImage imageNamed:strTemp];
    self.viewCard.backgroundColor = [UIColor colorWithPatternImage:imgTemp];
    
    strTemp = [dict valueForKey:kGiftFrame];
    imgTemp = [UIImage imageNamed:strTemp];
    self.imvFrameCard.image = imgTemp;
    
    strTemp = [dict valueForKey:kGiftMessage];
    //Set message
}

#pragma mark - Notifications
-(void) sendGiftView:(NSNotification *) notification
{
    Friend *toFriend = notification.object;

    NSString *projectPath = _giftPath;
    
    [[FunctionObject sharedInstance] createNewFolder:kPackages];
    NSString *docspath = [[FunctionObject sharedInstance] dataFilePath:kPackages];
    NSString *zipFile1 = [docspath stringByAppendingPathComponent:[_giftPath lastPathComponent]];
    NSString *zipFile = [zipFile1 stringByAppendingPathExtension:@"zip"];
    
    [[FunctionObject sharedInstance] saveAsZipFromPath:projectPath toPath:zipFile withCompletionBlock:^(NSString *pathResult) {
        
        SendGiftViewController *sgvc = [[SendGiftViewController alloc] initWithNibName:@"SendGiftViewController" bundle:nil];
        sgvc.toFriend = toFriend;
        sgvc.pathGift = pathResult;
        
        UINavigationController *navSendGift = [[UINavigationController alloc] initWithRootViewController:sgvc];
        [self.navigationController presentModalViewController:navSendGift animated:YES];
    }];
}



@end
