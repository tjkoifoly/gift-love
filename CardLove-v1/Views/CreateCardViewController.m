//
//  CreateCardViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "CreateCardViewController.h"
#import "GestureImageView.h"
#import "GestureView.h"
#import "GiftItemManager.h"
#import "MBProgressHUD.h"
#import "ZipArchive.h"
#import "GestureLabel.h"
#import "UILabel+dynamicSizeMe.h"
#import "ViewStyle.h"
#import "MusicViewController.h"
#import "AnimationsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MacroDefine.h"

#define kCanvasSize     200
#define kImageMaxSize   400

const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface CreateCardViewController ()
{
    GestureLabel *_selectedLabel;
    
    GestureView *focusObject;
    GestureImageView* currentPhoto;
    UIAlertView *photoAlert;
    UIAlertView *backAlert;
    ViewStyle *toolViewStyle;
    
    NSString *currentMusic;
    NSString *strCurrentEffect;
    UIEffectDesignerView *currentEffect;
}

@property (strong, nonatomic) NSString *pathResources;
@property (strong, nonatomic) NSString *pathConf;

@end

@implementation CreateCardViewController

@synthesize toolBar;
@synthesize pathConf        = _pathConf;
@synthesize pathResources   = _pathResources;
@synthesize exportMenu      = _exportMenu;
@synthesize giftName        = _giftName;

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
    [self createNewFolder:kProjects];
    [self createNewFolder:kCards];
    [self createNewFolder:kGift];
    [self createNewFolder:kPackages];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"] ];
    
    UIColor *c = [UIColor colorWithRed:0.65454 green:0.2454 blue:0.7345 alpha:1];
    NSLog(@"___COLOR = %@", c);
    
    toolViewStyle = [[[NSBundle mainBundle] loadNibNamed:@"ViewStyle" owner:self options:nil] objectAtIndex:0];
    [toolViewStyle setFrame:CGRectMake(0, 480, 320, 300)];
    [self.view addSubview:toolViewStyle];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //GIFT NAME
    if (!_giftName) {
        _giftName = kNewProject;
        _pathResources = [self dataFilePath:_giftName];

        self.navigationItem.title = @"New Gift";
    }else
    {
        NSString *pathProjs = [self dataFilePath:kProjects];
        _pathResources = [pathProjs stringByAppendingPathComponent:_giftName];

        self.navigationItem.title = _giftName;        
    }
    NSLog(@"PATH = %@", _pathResources);
    _pathConf = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kIndex]];
    
    //Sound Manager
    [SoundManager sharedManager].allowsBackgroundMusic = NO;
    [[SoundManager sharedManager] prepareToPlay];

    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCard)];
    UIBarButtonItem *btnSend = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showExportMenu)];
    NSArray *arrButtons = [NSArray arrayWithObjects:btnSave, btnSend, nil];
    
    self.navigationItem.rightBarButtonItems = arrButtons;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnRemove = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeCurrentItem)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:btnBack], btnRemove, nil] ;
    
     [toolBar setFrame:CGRectMake(0, 480, 320, 54)];
    [self.view addSubview:toolBar];
    [self performSelector:@selector(showToolBar) withObject:nil afterDelay:0.2f];
    
    self.viewCard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cover-01.png"]];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    

    BOOL isDir;
    if ([fileManager fileExistsAtPath:_pathResources isDirectory:&isDir]) {
        if (isDir) {
            
            [self loadGiftView];
            [self loadGiftLabels];
            [self loadGIFElement];
            [self loadMusic];
            [self loadAnimation];
        }
    }else
    {
        [self createNewFolder:_giftName];
    }
}

-(void) backPreviousView
{
    if ([[SoundManager sharedManager] isPlayingMusic]) {
        [[SoundManager sharedManager] stopMusic];
    }
    
    if ([_exportMenu isOpen]) {
        [_exportMenu closeWithCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setToolBar:nil];
    [self setViewCard:nil];
    [self setImvFrameCard:nil];
    [self setViewGift:nil];
    [self setGiftName:nil];
    [self setExportMenu:nil];
    [self setPathConf:nil];
    [self setPathResources:nil];
    [super viewDidUnload];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - LOAD CARD
-(void) loadGiftView
{
    [[GiftItemManager sharedManager] setPathData:_pathConf];
    NSArray *listItems = [[GiftItemManager sharedManager] getListItems];
    NSLog(@"LIST = %@", listItems);
    
    for(GiftItem *gi in listItems)
    {
        [self addViewPhotoWithItem:gi];
    }
}

-(void) loadGiftLabels
{
    NSString *pathLabels = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kGiftLabel]];
    NSLog(@"PATH Label = %@", pathLabels);
    [[GiftLabelsManager sharedManager] setPathData:pathLabels];
    
    NSArray *listLabels = [[GiftLabelsManager sharedManager] getListLabels];
    
    for(GiftLabel *gl in listLabels)
    {
        //Add label to view
        [self addGestureLabelWithGiftLabel:gl];
    }
}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                  NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}

-(void)createNewFolder: (NSString *)foleder
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    newDir = [docsDir stringByAppendingPathComponent:foleder];
    
    BOOL isDir;
    if([filemgr fileExistsAtPath:newDir isDirectory:&isDir])
    {
        if (!isDir) {
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
                NSLog(@" Failed to create directory");
            }
        }
    }else if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
        NSLog(@" Failed to create directory");
    }
}


#pragma mark - Instance Methods

-(void) saveCard
{
    if ([kNewProject isEqualToString:_giftName]) {
        //Show popUp to rename
        [self showNameAlertWithTitle:@"Enter a name for gift"];
    }else
    {
        [self saveData];
    }
}

-(void) saveData
{
    [self saveMusic];
    [self saveAnimation];
    
    NSMutableArray *listItems = [[NSMutableArray alloc] init];
    NSMutableArray *listLabels = [[NSMutableArray alloc] init];
    NSMutableArray *listElements = [[NSMutableArray alloc] init];
    
    NSArray *arrPhotos = [self.viewCard subviews];
    NSLog(@"ARR = %@", arrPhotos);
    
    for(UIView *subview in arrPhotos)
    {
        if([subview isKindOfClass:[GestureView class]])
        {
            GestureView *temp = (GestureView *) subview;
            
            GiftItem *gi = [[GiftItem alloc] initWithGestureView:temp];
            [listItems addObject:gi];
        }else if ([subview isKindOfClass:[GestureLabel class]])
        {
            GestureLabel *gtemp = (GestureLabel *) subview;
            GiftLabel *gl = [[GiftLabel alloc] initWithGestureLabel:gtemp];
            [listLabels addObject:gl];
        }else if ([subview isKindOfClass:[GestureImageView class]])
        {
            GestureImageView *etem = (GestureImageView *)subview;
            GiftElement *ge = [[GiftElement alloc] initWithGestureImageView:etem];
            [listElements addObject:ge];
        }
        
    }
    
    [[GiftItemManager sharedManager] setListItems:listItems];
    [[GiftLabelsManager sharedManager] setListLabels:listLabels];
    [[GiftElementsManager sharedManager] setListElenemts:listElements];
    
    if ([[GiftItemManager sharedManager] saveList]) {
        if ([[GiftLabelsManager sharedManager] saveListLabel]) {
            if ([[GiftElementsManager sharedManager] saveListElements]) {
                NSLog(@"Saved gift successful.");
            }
        }
    }
    
    NSLog(@"PHOTOS = %@", listItems);
}

-(void) showNameAlertWithTitle: (NSString *) titleText
{
    PromptAlert *pAlert = [[PromptAlert alloc] initWithTitle:titleText delegate:self cancelButtonTitle:@"OK" otherButtonTitle:@"Cancel"];
    [pAlert show];
}


#pragma mark -
#pragma mark - EXPORT MENU

-(void)showExportMenu
{
    if (_exportMenu.isOpen)
        return [_exportMenu close];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Run Demo"
                                                    subtitle:@"Run demo of gift"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          [self runDemo];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Export as image"
                                                       subtitle:@"Rending gift as image"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [self saveAsImage];
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Package gift"
                                                        subtitle:@"Package gift as a zip file"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              [self saveAsZip];
                                                          }];
    
    REMenuItem *saveProjectItem = [[REMenuItem alloc] initWithTitle:@"Send gift"
                                                           subtitle:@"Send gift to your friend"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [self sendGift];
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    saveProjectItem.tag = 3;
    
    _exportMenu = [[REMenu alloc] initWithItems:@[ homeItem, exploreItem, activityItem, saveProjectItem]];
    _exportMenu.cornerRadius = 4;
    _exportMenu.shadowColor = [UIColor blackColor];
    _exportMenu.shadowOffset = CGSizeMake(0, 1);
    _exportMenu.shadowOpacity = 1;
    _exportMenu.imageOffset = CGSizeMake(5, -1);
    
    [_exportMenu showFromNavigationController:self.navigationController];
}

-(NSString *) saveAsZip
{
    [self createNewFolder:kPackages];
    NSString *projectPath = _pathResources;
    
    NSString *docspath = [self dataFilePath:kPackages];
    
    NSString *zipFile = [docspath stringByAppendingPathComponent:_giftName];
    
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

-(void) saveAsImage
{
    NSString *cardsPath = [self dataFilePath:kCards];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", _giftName];
    NSString *filePath = [cardsPath stringByAppendingPathComponent:fileName];
    
//    UIImage *imageSaved = [self imageCaptureSave:self.viewCard];
//    UIImageView *imvFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 390)];
//    imvFrame.image = [UIImage imageNamed:@"card-frame-4.png"];
//    UIImageView *imvCard = [[UIImageView alloc] initWithImage:imageSaved];
//    imvCard.center = CGPointMake(imvFrame.bounds.size.width/2, imvFrame.bounds.size.height/2);
//    [imvFrame addSubview:imvCard];
//    UIImage *finalImage = [self imageCaptureSave:imvFrame];
    UIImage *finalImage = [self imageCaptureSave:self.viewGift];
    
    NSData *dataImage = [NSData dataWithData:UIImagePNGRepresentation(finalImage)];
    [dataImage writeToFile:filePath atomically:YES];
    
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);

}

-(void) runDemo
{
    [self saveData];
    
    if ([[SoundManager sharedManager] isPlayingMusic]) {
        [[SoundManager sharedManager] stopMusic];
    }
    
    ViewGiftViewController *vgvc = [[ViewGiftViewController alloc] initWithNibName:@"ViewGiftViewController" bundle:nil];
    vgvc.giftPath = _pathResources;
    vgvc.delegate = self;
    
    DoorsTransition *transition = [[DoorsTransition alloc] init];
    transition.transitionType = DoorsTransitionTypeOpen;
    
    [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];
    [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:vgvc onViewController:self.navigationController];
}

#pragma mark - View Gift Delegate
-(void) modalControllerDidFinish:(ViewGiftViewController *)modalController
{
    DoorsTransition *transition = [[DoorsTransition alloc] init];
    transition.transitionType = DoorsTransitionTypeOpen;
    
    [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];
	[[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:modalController];
}

-(void) sendGift
{
    NSString *docspath = [self dataFilePath:kPackages];
    NSString *zipFile = [docspath stringByAppendingPathComponent:_giftName];
    
    NSString *projectPath = [self dataFilePath:kGift];
    NSString *unzipPath = [projectPath stringByAppendingPathComponent:_giftName];
    NSFileManager *fmgr = [[NSFileManager alloc] init] ;
    
   [fmgr createDirectoryAtPath:unzipPath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    if ([fmgr fileExistsAtPath:unzipPath]) {
        ZipArchive *za = [[ZipArchive alloc] init];
        if ([za UnzipOpenFile:zipFile]) {
           BOOL ret = [za UnzipFileTo:unzipPath overWrite:YES];
            if (NO == ret){} [za UnzipCloseFile];
        }
    }
    
}
/* ------------------------------------------------------------------------------------------- */
-(void) removeImageView
{
    if (!currentPhoto) {
        return;
    }
    
    NSFileManager *fmgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    if ([fmgr removeItemAtPath:currentPhoto.imgURL error:&error]) {
        NSLog(@"Removed photo.");
        
        GiftItem *itemDeleted1 = (GiftItem*) [[GiftItemManager sharedManager] findGiftByImageURL:currentPhoto.imgURL];
        NSLog(@"Delete Item = %@", [itemDeleted1.photo lastPathComponent] );
        [[GiftItemManager sharedManager] removeGiftItem:itemDeleted1];
    }

    [UIView animateWithDuration:0.5 animations:^{
        currentPhoto.transform =
        CGAffineTransformMakeTranslation(
                                         currentPhoto.frame.origin.x,
                                         480.0f + (currentPhoto.frame.size.height/2)  // move the whole view offscreen
                                         );
        currentPhoto.alpha = 0; // also fade to transparent
    } completion:^(BOOL finished) {
        [currentPhoto removeFromSuperview];
    }];

}

-(void) removeItem: (UIView *)itemToDel
{
    if ([itemToDel isKindOfClass:[GestureLabel class]]) {
        if (!_selectedLabel) {
            return;
        }
        
        GiftLabel *itemDeleted = (GiftLabel *)[[GiftLabelsManager sharedManager] findLabelByID:_selectedLabel.labelID];
        [[GiftLabelsManager sharedManager] removeLabel:itemDeleted];
        
        [UIView animateWithDuration:0.5 animations:^{
            _selectedLabel.transform =
            CGAffineTransformMakeTranslation(
                                             _selectedLabel.frame.origin.x,
                                             480.0f + (_selectedLabel.frame.size.height/2)  // move the whole view offscreen
                                             );
            _selectedLabel.alpha = 0; // also fade to transparent
        } completion:^(BOOL finished) {
            [_selectedLabel removeFromSuperview];
        }];
    }else if ([itemToDel isKindOfClass:[GestureView class]])
    {
        if (!focusObject) {
            return;
        }
        
        
        NSFileManager *fmgr = [[NSFileManager alloc] init];
        NSError *error = nil;
        
        if ([fmgr removeItemAtPath:focusObject.imgURL error:&error]) {
            NSLog(@"Removed photo.");
            
            GiftItem *itemDeleted = (GiftItem*) [[GiftItemManager sharedManager] findGiftByImageURL:focusObject.imgURL];
            NSLog(@"Delete Item = %@", [itemDeleted.photo lastPathComponent] );
            [[GiftItemManager sharedManager] removeGiftItem:itemDeleted];
        }
        
        
        [UIView animateWithDuration:0.5 animations:^{
            focusObject.transform =
            CGAffineTransformMakeTranslation(
                                             focusObject.frame.origin.x,
                                             480.0f + (focusObject.frame.size.height/2)  // move the whole view offscreen
                                             );
            focusObject.alpha = 0; // also fade to transparent
        } completion:^(BOOL finished) {
            [focusObject removeFromSuperview];
        }];
    }else if ([itemToDel isKindOfClass:[GestureImageView class]])
    {
        if (!currentPhoto) {
            return;
        }
        
        GiftElement *itemDeleted = (GiftElement *)[[GiftElementsManager sharedManager] findElementGiftByElementID:currentPhoto.elementID];
        [[GiftElementsManager sharedManager] removeElement:itemDeleted];

        [UIView animateWithDuration:0.5 animations:^{
            currentPhoto.transform =
            CGAffineTransformMakeTranslation(
                                             currentPhoto.frame.origin.x,
                                             480.0f + (currentPhoto.frame.size.height/2)  // move the whole view offscreen
                                             );
            currentPhoto.alpha = 0; // also fade to transparent
        } completion:^(BOOL finished) {
            [currentPhoto removeFromSuperview];
        }];
    }
}

- (void) removeCurrentItem
{
    [self removeItem:_selectedLabel];
    [self removeItem:focusObject];
    [self removeItem:currentPhoto];
}

-(void)removeGestureView
{
    if (!focusObject) {
        return;
    }
    
    
    NSFileManager *fmgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    if ([fmgr removeItemAtPath:focusObject.imgURL error:&error]) {
        NSLog(@"Removed photo.");
        
        GiftItem *itemDeleted = (GiftItem*) [[GiftItemManager sharedManager] findGiftByImageURL:focusObject.imgURL];
        NSLog(@"Delete Item = %@", [itemDeleted.photo lastPathComponent] );
        [[GiftItemManager sharedManager] removeGiftItem:itemDeleted];
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        focusObject.transform =
        CGAffineTransformMakeTranslation(
                                         focusObject.frame.origin.x,
                                         480.0f + (focusObject.frame.size.height/2)  // move the whole view offscreen
                                         );
        focusObject.alpha = 0; // also fade to transparent
    } completion:^(BOOL finished) {
        [focusObject removeFromSuperview];
    }];

}

-(void)showToolBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [toolBar setFrame:CGRectMake(0, 416-54, 320, 54)];
    
    [UIView commitAnimations];
    
}

-(void) showStyleView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = toolViewStyle.frame;
        frame.origin.y = 416 - frame.size.height;
        [toolViewStyle setFrame:frame];
    }];
}

-(void) hideStyleView
{
    [UIView animateWithDuration:0.5 animations:^{
        [toolViewStyle setFrame:CGRectMake(0, 480, 320, 300)];
    } completion:^(BOOL finished) {
        //[self showToolBar];
    }];
}

-(void) hideToolBarWithView: (UIView*) altView
{
    [UIView animateWithDuration:0.5 animations:^{
        //[toolBar setFrame:CGRectMake(0, 480, 320, 54)];
    } completion:^(BOOL finished) {
        [self showStyleView];
    }];
}

-(NSString *)generateRandomStringWithLength: (int) len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

-(NSString *) saveImagetoResources: (UIImage *) image 
{
    NSString *pngFilePath;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    do {
        NSString *pngFileName = [NSString stringWithFormat:@"%@.png", [self generateRandomStringWithLength:10]];
        pngFilePath = [_pathResources stringByAppendingPathComponent:pngFileName];
    } while ([fileManager fileExistsAtPath:pngFilePath]);
    
    UIImage *imageBySize = [self imageBySize:image];
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageBySize)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    return pngFilePath;
}

-(UIImage *)imageCaptureSave: (UIView *)viewInput
{
    CGSize viewSize = viewInput.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewInput.layer renderInContext:context];
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageX;
}

- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect

{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return cropped;
    
}


- (UIImage *)imageBySize:(UIImage *)image

{
    CGSize sizeRatio = [self resizeImage:image toMax:kImageMaxSize];
    
    UIImageView *canvasView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sizeRatio.width, sizeRatio.height)];
    canvasView.image = image;
    canvasView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *result = [self imageCaptureSave:canvasView];
    
    return result;
    
}

#pragma mark - ADD PHOTO

/* ----------------------------------------------------------------------------------*/


-(void) addViewPhoto: (UIImage *)image
{
    GestureView *gv = [[GestureView alloc] initWithType:GestureViewToEdit];
    gv.imgURL = [self saveImagetoResources:image];
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:gv inView:self.viewCard];
    
    [gv addLayersWithImage:image];
    gv.delegate = self;    

    GiftItem *item = [[GiftItem alloc] initWithGestureView:gv];
    [[GiftItemManager sharedManager] addItem:item];
    
    [self.viewCard addSubview:gv];
    
}

/* ----------------------------------------------------------------------------------*/

-(void) addViewPhotoWithItem: (GiftItem *) item
{
    GestureView *imvPhoto = [[GestureView alloc] initWithType:GestureViewToEdit];
    UIImage *image = [UIImage imageWithContentsOfFile:item.photo];
    
    imvPhoto.bounds = CGRectFromString(item.bounds);
    imvPhoto.center = CGPointFromString(item.center);
    imvPhoto.transform = CGAffineTransformFromString(item.transform);
    imvPhoto.imgURL = item.photo;
    
   [imvPhoto addLayersWithImage:image];
    imvPhoto.delegate = self;
    
    [self.viewCard addSubview:imvPhoto];
}

/* ----------------------------------------------------------------------------------*/



-(void) addViewPhoto: (UIImage *)image withURL:(NSString *) strURL
{
    GestureView *imvPhoto = [[GestureView alloc] initWithType:GestureViewToEdit];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    
    [imvPhoto addLayersWithImage:image];
    imvPhoto.delegate = self;
    imvPhoto.imgURL = strURL;
    
    GiftItem *item = [[GiftItem alloc] initWithGestureView:imvPhoto];
    [[GiftItemManager sharedManager] addItem:item];
    
    [self.viewCard addSubview:imvPhoto];

    [imvPhoto tapSingleDetected:nil];

}

/* ----------------------------------------------------------------------------------*/


-(void) addViewPhoto:(UIImage *)image withCenterPoint: (CGPoint)centerPoint andTransfrom: (CGAffineTransform) transform
{
    GestureView *imvPhoto = [[GestureView alloc] initWithType:GestureViewToEdit];
    
    imvPhoto.imgURL = [self saveImagetoResources:image];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    imvPhoto.center = centerPoint;
    imvPhoto.transform = transform;
    
    [imvPhoto addLayersWithImage:image];
    imvPhoto.delegate = self;
    
    GiftItem *item = [[GiftItem alloc] initWithGestureView:imvPhoto];
    [[GiftItemManager sharedManager] addItem:item];
    
    [self.viewCard addSubview:imvPhoto];
}

/* ----------------------------------------------------------------------------------*/

-(CGSize) resizeImage: (UIImage *)image toMax: (CGFloat) maxValue
{
    CGSize sizeImage = image.size;
    CGSize sizeRatio;
    if (sizeImage.width > sizeImage.height) {
        if (sizeImage.width <= maxValue) {
            return image.size;
        }
        sizeRatio.width = maxValue;
        sizeRatio.height = sizeImage.height/sizeImage.width * maxValue;
    }else
    {
        if (sizeImage.height <= maxValue) {
            return image.size;
        }
        sizeRatio.height = maxValue;
        sizeRatio.width = sizeImage.width/sizeImage.height * maxValue;
    }

    return sizeRatio;
}

-(void) flxibleFrameImage: (UIImage*) image withMaxValue:(CGFloat)maxValue forView: (UIView *)view inView: (UIView *) containerView
{
    CGSize sizeRatio = [self resizeImage:image toMax:maxValue];
    [view setFrame:CGRectMake(0,0, sizeRatio.width, sizeRatio.height)];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
}

-(void) flxibleFrameImage: (UIImage*) image withMaxValue:(CGFloat)maxValue forView:(UIView*) view
{
    CGPoint centerPoint = view.center;
    [self flxibleFrameImage:image withMaxValue:maxValue forView:view inView:self.viewCard];
    view.center = centerPoint;
}

//----------------------------------------------------------------------------------------------------//
#pragma mark -
#pragma mark - Gesture Label Delegate
-(void) displayEditorFor:(GestureLabel *)label
{
    CMTextStylePickerViewController *textStylePickerViewController = [CMTextStylePickerViewController textStylePickerViewController];
    textStylePickerViewController.delegate = self;
    textStylePickerViewController.labelToEdit = label;
		
    UINavigationController *actionsNavigationController = [[UINavigationController alloc] initWithRootViewController:textStylePickerViewController];

    [self presentModalViewController:actionsNavigationController animated:YES];
}

-(void) gestureLabelDidSelected:(GestureLabel *)label
{
    [label labelSelected];
    if (!_selectedLabel) {
        _selectedLabel = label;
         
        return;
    }
    
    if (_selectedLabel != nil && _selectedLabel != label) {
        NSLog(@"DCM");
        [_selectedLabel labelDeselected];
        _selectedLabel = label;
    }
}
//----------------------------------------------------------------------------------------------------//
#pragma mark - GestureImage Delegate
-(void) displayEditor: (GestureImageView *)gestureImageView forImage:(UIImage *)imageToEdit
{
    currentPhoto = gestureImageView;
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}

-(void) selectImageView:(GestureImageView *)gestureImageView
{
    if (currentPhoto) {
        [currentPhoto showBorder:NO];
    }
    currentPhoto = gestureImageView;
    [currentPhoto showBorder:YES];
}

#pragma mark -
#pragma mark - GestureViewDelegate
-(void) displayEditorWith:(GestureView *)gestureView forImage:(UIImage *)imageToEdit
{
    focusObject = gestureView;
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
   [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}

-(void) selectPhoto:(GestureView *)gestureView
{
    if (focusObject) {
        [focusObject selected:NO];
    }
    focusObject = gestureView;
    [focusObject selected:YES];
}

#pragma mark - AFPhotoEditor
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
//    NSLog(@"%@" , NSStringFromCGSize(image.size));
//    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:currentPhoto inView:self.viewCard];
//    ((GestureImageView *)currentPhoto).image = image;
//
    if (currentPhoto) {
        CGPoint center = ((GestureImageView *)currentPhoto).center;
        CGAffineTransform transform = currentPhoto.transform;
        [self removeImageView];
        
        [self addPhotoView:image withCenterPoint:center andTransfrom:transform];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    if (focusObject) {
        CGPoint center = ((GestureView *)focusObject).center;
        CGAffineTransform transform = focusObject.transform;

        [self removeGestureView];
        
        [self addViewPhoto:image withCenterPoint:center andTransfrom:transform];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
}
- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissModalViewControllerAnimated:YES];
    currentPhoto = nil;
}

#pragma mark - IBActions

- (IBAction)importPhoto:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add photo to gift" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take a photo" otherButtonTitles: @"Choose from library",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

- (IBAction)addText:(id)sender {
    
    CMTextStylePickerViewController *textStylePickerViewController = [CMTextStylePickerViewController textStylePickerViewController];
	textStylePickerViewController.delegate = self;
		
	UINavigationController *actionsNavigationController = [[UINavigationController alloc] initWithRootViewController:textStylePickerViewController];
    
	[self presentModalViewController:actionsNavigationController animated:YES];
}

- (IBAction)addAnimation:(id)sender {
    
    AnimationsViewController *avc = [[AnimationsViewController alloc] initWithNibName:@"AnimationsViewController" bundle:nil];
    avc.currentEffect = strCurrentEffect;
    avc.delegate = self;
    UINavigationController *navAnimation = [[UINavigationController alloc] initWithRootViewController:avc];
    [self presentModalViewController:navAnimation animated:YES];
    
}
- (IBAction)editPhoto:(id)sender {
    
//    if (currentPhoto) {
//        if (toolViewStyle.frame.origin.y > 460) {
//            toolViewStyle.viewToEdit = currentPhoto;
//            [self showStyleView];
//        }else
//        {
//            [self hideStyleView];
//        }
//    }
    GiftElementsViewController *gevc = [[GiftElementsViewController alloc] initWithNibName:@"GiftElementsViewController" bundle:nil];
    gevc.delegate = self;
    UINavigationController *navGif = [[UINavigationController alloc] initWithRootViewController:gevc];
    [self presentModalViewController:navGif animated:YES];
}

- (IBAction)addMusic:(id)sender {
    
    NSLog(@"Play Sound");
    MusicViewController *msvc = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
    msvc.selectingMusic = currentMusic;
    msvc.delegate = self;
    UINavigationController *navMusic = [[UINavigationController alloc] initWithRootViewController:msvc];
    [self presentModalViewController:navMusic animated:YES];

    if ([SoundManager sharedManager].isPlayingMusic) {
        [[SoundManager sharedManager] stopMusic];
    }

    
}

#pragma mark - ActionSheet

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"Take a photo by camera");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self photoPicker:UIImagePickerControllerSourceTypeCamera];
            }else
            {
                photoAlert = [[UIAlertView alloc ]initWithTitle:@"Failed" message:@"Camera isn't available on device" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Album", nil];
                [photoAlert show];
            }
            break;
        }
        case 1:
            NSLog(@"Choose a photo from library");
            [self photoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerController

-(void) photoPicker : (UIImagePickerControllerSourceType) pickerSourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = pickerSourceType;
    
    [self presentModalViewController:picker animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    //NSLog(@"KEY = %@", [info allKeys]);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSString *imgURL = [[info objectForKey:UIImagePickerControllerMediaURL] absoluteString];
    //[self addPhotoView:image];
    [self addViewPhoto:image];
    NSLog(@"Add image = %@", image);
}

#pragma mark - AlertView

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == photoAlert) {
        switch (buttonIndex) {
            case 1:
            {
                [self photoPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
                break;
                
            default:
                break;
        }

    }else if (alertView == backAlert)
    {
        
    }else if ([alertView isKindOfClass:[PromptAlert class]])
    {
        
        switch (buttonIndex) {
            case 0:
            {
                PromptAlert *pAlert = (PromptAlert *) alertView;
                NSString *nameOfGift = pAlert.filedName.text;
                
                if ([nameOfGift rangeOfString:@"/"].location == NSNotFound) {
                    NSLog(@"Name of gift is %@", nameOfGift);
                    
                    [self namingGift:nameOfGift];
                    
                }else
                {
                    [self showNameAlertWithTitle: @"Enter a other name"];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

-(void) namingGift: (NSString *) nameOfGift
{
    NSString *oldDirectoryPath = _pathResources;
    
    NSString *pathPorjects = [self dataFilePath:kProjects];
    NSString *pathOfThisGift = [pathPorjects stringByAppendingPathComponent:nameOfGift];
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathOfThisGift isDirectory:&isDir]) {

        if (isDir) {
            [self showNameAlertWithTitle: @"Enter a other name"];
        }
        return;
    }
    
    if ([[NSFileManager defaultManager] createDirectoryAtPath:pathOfThisGift withIntermediateDirectories:YES attributes:nil error:NULL]) {
        NSLog(@"Create directory - %@ succcessful", nameOfGift);
        
        NSArray *tempArrayForContentsOfDirectory =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:oldDirectoryPath error:nil];
        
        for (int i = 0; i < [tempArrayForContentsOfDirectory count]; i++)
        {
            
            NSString *newFilePath = [pathOfThisGift stringByAppendingPathComponent:[tempArrayForContentsOfDirectory objectAtIndex:i]];
            
            NSString *oldFilePath = [oldDirectoryPath stringByAppendingPathComponent:[tempArrayForContentsOfDirectory objectAtIndex:i]];
            
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:&error];
            
            if (error) {
                // handle error
                NSLog(@"-----> ERROR move file! = %@", error);
                
            }else
            {
                _giftName = nameOfGift;
                _pathResources = pathOfThisGift;
                _pathConf = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kIndex]];
                [[GiftItemManager sharedManager] setPathData:_pathConf];
                
                NSString *pathLabels = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kGiftLabel]];
                [[GiftLabelsManager sharedManager] setPathData:pathLabels];
                
                NSString *pathEles = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kElements]];
                [[GiftElementsManager sharedManager]setPathData:pathEles];

                
                NSArray *arrPhotos = [self.viewCard subviews];
                NSLog(@"ARR = %@", arrPhotos);
                
                for(UIView *subview in arrPhotos)
                {
                    if([subview isKindOfClass:[GestureView class]])
                    {
                        GestureView *temp = (GestureView *) subview;
                        
                        NSString *mPath = temp.imgURL;
                        temp.imgURL = [mPath stringByReplacingOccurrencesOfString:oldDirectoryPath withString:_pathResources];
                        NSLog(@"URL PHOTO = %@", temp.imgURL);
                    }
                }
                //END for
                
                
            }//END if
            
        }//END for
        
        [self saveData];
        
    }else
    {
        NSLog(@"Failed to create directory - %@", nameOfGift);
    }
}

-(void) showMessageWithCompletedView: (NSString *) message
{
    UIImageView *completedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	
	[self showMessage:message withCustomView:completedView];
}

-(void) showMessage: (NSString *)message withCustomView :(UIView *)customView
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.customView = customView;
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = message;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:1];

}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
}

#pragma mark - Touch Event
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event touchesForView:focusObject] anyObject]) {
        return;
    }else
    {
        [self focusItemDeslected:focusObject];
    }
    
    if ([[event touchesForView:currentPhoto] anyObject]) {
        return;
    }else
    {
        [self currentItemDeslected:currentPhoto];
    }
    
    if ([[event touchesForView:_selectedLabel] anyObject]) {
        return;
    }else{
        [self currentLabelDeselected:_selectedLabel];
    }
    
}

-(void) currentLabelDeselected: (GestureLabel *) currentLabel
{
    [currentLabel labelDeselected];
    currentLabel = nil;
}

-(void)currentItemDeslected : (GestureImageView *)currentItem
{
    [currentItem showBorder:NO];
    currentItem = nil;
}
-(void)focusItemDeslected : (GestureView *)focusItem
{
    [focusItem selected:NO];
    focusObject = nil;
}

#pragma mark -
#pragma mark CMTextStylePickerViewControllerDelegate methods

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedFont:(UIFont *)font {
	
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedTextColor:(UIColor *)textColor {
	
}

- (void)textStylePickerViewControllerSelectedCustomStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use custom text style
	
}

- (void)textStylePickerViewControllerSelectedDefaultStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use default text style
	
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController replaceDefaultStyleWithFont:(UIFont *)font textColor:(UIColor *)textColor {
	
}

- (void)textStylePickerViewControllerIsDone:(CMTextStylePickerViewController *)textStylePickerViewController {
    
	[self dismissModalViewControllerAnimated:YES];
}

-(void) textStylePickerViewControllerAdd:(CMTextStylePickerViewController *)textStylePickerVC withLabel:(UILabel *)labelToAdd
{
    [self addGestureLabelWithLabel:labelToAdd];
}

#pragma mark -
#pragma mark - Gesture label
-(void) addGestureLabelWithLabel: (UILabel *) labelToAdd
{
    if ([labelToAdd.text isEqualToString:@""]) {
        return;
    }
    
    // Create a blinking text
    NSInteger randomID ;
    
    GestureLabel* labelText = [[GestureLabel alloc] initWithType:GestureLabelToEdit];
    
    do {
        randomID = arc4random() % 1000;
        NSLog(@"ID = %i", randomID);
    } while ([[GiftLabelsManager sharedManager] findLabelByID:[NSString stringWithFormat:@"%i", randomID]]);
    labelText.labelID = [NSString stringWithFormat:@"%i", randomID];
    labelText.delegate = self;
    
    labelText.text = labelToAdd.text;
    labelText.backgroundColor = [UIColor clearColor];

    [self.viewCard addSubview:labelText];
    CGRect frame1 = labelText.frame;
    
    CGFloat width = [labelToAdd.text sizeWithFont:labelToAdd.font].width;
    if (width < labelToAdd.frame.size.width) {
        frame1.size.width = width;
    }else
    {
        
        frame1.size.width = labelToAdd.frame.size.width;
    }
    labelText.frame = frame1;
    labelText.font = labelToAdd.font;
    labelText.textColor = labelToAdd.textColor;
    labelText.center = CGPointMake(self.viewCard.bounds.size.width/2, self.viewCard.bounds.size.height/2);
    [labelText resizeToFit];
    NSLog(@"Transform = %@", NSStringFromCGAffineTransform(labelText.transform));
    
    GiftLabel *gLabel = [[GiftLabel alloc] initWithGestureLabel:labelText];
    [[GiftLabelsManager sharedManager] addLabel:gLabel];
  }

-(void) addGestureLabelWithGiftLabel: (GiftLabel *) gLabel
{
    if (!gLabel) {
        return;
    }
    
    GestureLabel * labelText = [[GestureLabel alloc] initWithType:GestureLabelToEdit];
    labelText.backgroundColor = [UIColor clearColor];
    
    labelText.labelID = gLabel.labelID;
    labelText.bounds = CGRectFromString(gLabel.bounds);
    labelText.center = CGPointFromString(gLabel.center);
    labelText.transform = CGAffineTransformFromString(gLabel.transform);
    labelText.delegate = self;
    
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

-(void) shakeView: (UIView*) viewToAnimation
{
    //
    void (^animationLabel) (void) = ^{
            viewToAnimation.alpha = 0;
    };
    void (^completionLabel) (BOOL) = ^(BOOL f) {
        viewToAnimation.alpha = 1;
    };

    NSUInteger opts =  UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat;
    [UIView animateWithDuration:1.f delay:0 options:opts
                    animations:animationLabel completion:completionLabel];
}

#pragma mark - 
#pragma mark - MUSIC
-(void) loadMusic
{
    NSString *pathMusic = [_pathResources stringByAppendingPathComponent:kMusic];
    NSError *error;
    currentMusic = [NSString stringWithContentsOfFile:pathMusic encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"MUSIC = %@", currentMusic);
    
    if (![currentMusic isEqualToString:@""]) {
        [self playMusic:currentMusic];
    }
}

-(void) saveMusic
{
    NSString *pathMusic = [_pathResources stringByAppendingPathComponent:kMusic];
    NSError *error;
    [currentMusic writeToFile:pathMusic atomically:YES encoding:NSUTF8StringEncoding error:&error];
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

-(void) setMusicVolume: (CGFloat) value
{
    [[SoundManager sharedManager] setMusicVolume:value];
}

#pragma mark - Music View Controller Delegate
-(void) musicViewControllerCancel
{
    [self playMusic:currentMusic];
}

-(void) musicViewControllerDoneActionWithMusic:(NSString *)musicName
{
    currentMusic = musicName;
    [self playMusic:currentMusic];
}

#pragma mark - Animaion
-(void) loadAnimation
{
    NSString *pathAnimation = [_pathResources stringByAppendingPathComponent:kAnimation];
    NSError *error;
    strCurrentEffect = [NSString stringWithContentsOfFile:pathAnimation encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"ANIMATION = %@", strCurrentEffect);
    
    if ((strCurrentEffect != nil) && (![kNoEff isEqualToString: strCurrentEffect])) {
        currentEffect = [UIEffectDesignerView effectWithFile:strCurrentEffect];
        [self.imvFrameCard addSubview:currentEffect];
    }
}

-(void) saveAnimation
{
    NSString *pathAnimation = [_pathResources stringByAppendingPathComponent:kAnimation];
    NSError *error;
    [strCurrentEffect writeToFile:pathAnimation atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
}

-(void) noEffectAnitmation
{
    [currentEffect removeFromSuperview];
    strCurrentEffect = kNoEff;
}

#pragma mark - Animation Delegate
-(void) animationViewControllerCancel
{
    
}

-(void) animationVIewControllerDone:(NSString *)strEffect
{
    if (![strEffect isEqualToString:strCurrentEffect]) {
        strCurrentEffect = strEffect;
        if (currentEffect) {
            [currentEffect removeFromSuperview];
        }
        if (![kNoEff isEqualToString: strCurrentEffect]) {
            currentEffect = [UIEffectDesignerView effectWithFile:strCurrentEffect];
            [self.imvFrameCard addSubview:currentEffect];
        }
    }
    
}

-(void) addShakingAnimationToView: (UIView *)viewAnimation
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                                CGPointMake([viewAnimation center].x - 20.0f, [viewAnimation center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([viewAnimation center].x + 20.0f, [viewAnimation center].y)]];
    [[viewAnimation layer] addAnimation:animation forKey:@"position"];

}

#pragma mark - 
#pragma mark - GIF Method
-(void) loadGIFElement
{
    NSString *pathElements = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:kElements]];
    [[GiftElementsManager sharedManager] setPathData:pathElements];
    NSArray *listElements = [[GiftElementsManager sharedManager] getListElements];
    NSLog(@"LIST = %@", listElements);
    
    for(GiftElement *gi in listElements)
    {
        [self addPhotoViewWithItem:gi];
    }
}


-(void) addGifElementWithName: (NSString *)imageName
{
    UIImage *image = [OLImage imageNamed:imageName];
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image withType:GestureImageViewToEdit];
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    
    NSInteger randomID ;
    do {
        randomID = arc4random() % 1000;
        NSLog(@"ID = %i", randomID);
    } while ([[GiftElementsManager sharedManager] findElementGiftByElementID:[NSString stringWithFormat:@"%i", randomID]]);
    imvPhoto.elementID = [NSString stringWithFormat:@"%i", randomID];
    imvPhoto.imgURL = imageName;
    imvPhoto.delegate = self;
    [self.viewCard addSubview:imvPhoto];
    
    GiftElement *item = [[GiftElement alloc] initWithGestureImageView:imvPhoto];
    [[GiftElementsManager sharedManager] addElement:item];

}

-(void) addPhotoViewWithItem: (GiftElement *) item
{
    UIImage *image = [OLImage imageNamed:item.imageURL];
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image withType:GestureImageViewToEdit];
    imvPhoto.bounds = CGRectFromString(item.bounds);
    imvPhoto.center = CGPointFromString(item.center);
    imvPhoto.transform = CGAffineTransformFromString(item.transform);
    imvPhoto.imgURL = item.imageURL;
    imvPhoto.elementID = item.elementID;
    imvPhoto.delegate = self;
    [self.viewCard addSubview:imvPhoto];

}

-(void) addPhotoView: (UIImage *)image withURL:(NSString *) strURL
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image withType:GestureImageViewToEdit];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    imvPhoto.imgURL = strURL;
    
    GiftItem *item = [[GiftItem alloc] initWithView:imvPhoto];
    [[GiftItemManager sharedManager] addItem:item];
    
    [self.viewCard addSubview:imvPhoto];
    currentPhoto = imvPhoto;
}
-(void) addPhotoView:(UIImage *)image withCenterPoint: (CGPoint)centerPoint andTransfrom: (CGAffineTransform) transform
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image withType:GestureImageViewToEdit];
    
    imvPhoto.imgURL = [self saveImagetoResources:image];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    imvPhoto.center = centerPoint;
    imvPhoto.transform = transform;
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    
    GiftItem *item = [[GiftItem alloc] initWithView:imvPhoto];
    [[GiftItemManager sharedManager] addItem:item];
    
    [self.viewCard addSubview:imvPhoto];
}


#pragma mark - GiftElementDelegate

-(void) giftElementsViewControllerDidSelected:(NSString *)elementName
{
    [self addGifElementWithName:elementName];
}


@end
