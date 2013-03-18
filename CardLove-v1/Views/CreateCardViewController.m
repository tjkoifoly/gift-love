//
//  CreateCardViewController.m
//  CardLove-v1
//
//  Created by FOLY on 2/25/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "CreateCardViewController.h"
#import "GestureImageView.h"
#import "GiftItemManager.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

#define kNewProject @"NewTemplate"

#define kCanvasSize 200

const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface CreateCardViewController ()
{
    GestureImageView* currentPhoto;
    UIAlertView *photoAlert;
    UIAlertView *backAlert;
}
@property (strong, nonatomic) NSString *pathResources;
@property (strong, nonatomic) NSString *pathConf;

-(void) addPhotoView: (UIImage *)image;

@end

@implementation CreateCardViewController

@synthesize toolBar;
@synthesize pathConf = _pathConf;
@synthesize pathResources =_pathResources;
@synthesize exportMenu =_exportMenu;

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
    
    self.navigationItem.title = @"New Gift";
    
//    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSave setBackgroundImage:[UIImage imageNamed:@"save-button.png"] forState:UIControlStateNormal];
//    btnSave.frame = CGRectMake(0, 0, 30, 30);
//    [btnSave addTarget:self action:@selector(saveCard) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSend setBackgroundImage:[UIImage imageNamed:@"mail-button.png"] forState:UIControlStateNormal];
//    btnSend.frame = CGRectMake(0, 0, 30, 30);
//    [btnSend addTarget:self action:@selector(sendCard) forControlEvents:UIControlEventTouchUpInside];
//    
//    NSArray *arrButtons = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:btnSend], [[UIBarButtonItem alloc] initWithCustomView:btnSave], nil];
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCard)];
    UIBarButtonItem *btnSend = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(showExportMenu)];
    NSArray *arrButtons = [NSArray arrayWithObjects:btnSave, btnSend, nil];
    
    self.navigationItem.rightBarButtonItems = arrButtons;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnRemove = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeImageView)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:btnBack], btnRemove, nil] ;
    
     [toolBar setFrame:CGRectMake(0, 480, 320, 54)];
    [self.view addSubview:toolBar];
    [self performSelector:@selector(showToolBar) withObject:nil afterDelay:0.2f];
    
    self.viewCard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"font-frame.png"]];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    _pathResources = [self dataFilePath:kNewProject];
    NSLog(@"PATH = %@", _pathResources);
    _pathConf = [_pathResources stringByAppendingPathComponent:[NSString stringWithFormat:@"index.tjkoifoly"]];

    BOOL isDir;
    if ([fileManager fileExistsAtPath:_pathResources isDirectory:&isDir]) {
        if (isDir) {
            [self loadGiftView];
        }
    }else
    {
        [self createNewFolder];
    }
}

-(void) backPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setToolBar:nil];
    [self setViewCard:nil];
    [super viewDidUnload];
}

-(void) loadGiftView
{
    [[GiftItemManager sharedManager] setPathData:_pathConf];
    NSArray *listItems = [[GiftItemManager sharedManager] getListItems];
    
    for(GiftItem *gi in listItems)
    {
        [self addPhotoViewWithItem:gi];
    }
}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                  NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}

-(void)createNewFolder
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    newDir = [docsDir stringByAppendingPathComponent:kNewProject];
    _pathResources = newDir;
    
    if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
        NSLog(@" Failed to create directory");
    }else
    {
        _pathConf = [newDir stringByAppendingPathComponent:[NSString stringWithFormat:@"index.tjkoifoly"]];
        NSLog(@"PATH = %@", _pathConf);
    }
}

#pragma mark - Instance Methods

-(void) saveCard
{
    NSMutableArray *listItems = [[NSMutableArray alloc] init];
    NSArray *arrPhotos = [self.viewCard subviews];
    NSLog(@"ARR = %@", arrPhotos);
    
    for(UIView *subview in arrPhotos)
    {
        if([subview isKindOfClass:[GestureImageView class]])
        {
            GestureImageView *temp = (GestureImageView *) subview;
            
            GiftItem *gi = [[GiftItem alloc] initWithView:temp];
            [listItems addObject:gi];
        }
    }
    
    if ([[GiftItemManager sharedManager] saveList:listItems toPath:_pathConf]) {
        [self showMessageWithCompletedView:@"Saved"];
    }
    
    
    NSLog(@"PHOTOS = %@", listItems);
}

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
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Save as image"
                                                       subtitle:@"Save gift as image to send by email"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Package gift"
                                                        subtitle:@"Package gift as a zip file"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Send gift"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
    
    _exportMenu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    _exportMenu.cornerRadius = 4;
    _exportMenu.shadowColor = [UIColor blackColor];
    _exportMenu.shadowOffset = CGSizeMake(0, 1);
    _exportMenu.shadowOpacity = 1;
    _exportMenu.imageOffset = CGSizeMake(5, -1);
    
    [_exportMenu showFromNavigationController:self.navigationController];
}

-(void) removeImageView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        NSFileManager *fmgr = [[NSFileManager alloc] init];
        NSError *error = nil;
        
        if ([fmgr removeItemAtPath:currentPhoto.imgURL error:&error]) {
            NSLog(@"Removed photo.");
        }
        
        [currentPhoto removeFromSuperview];
        
        
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
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    return pngFilePath;
}

-(void) addPhotoView: (UIImage *)image
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image];
    
    imvPhoto.imgURL = [self saveImagetoResources:image];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    
    [self.viewCard addSubview:imvPhoto];
    currentPhoto = imvPhoto;
}

-(void) addPhotoViewWithItem: (GiftItem *) item
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:item.photo]];
    imvPhoto.bounds = CGRectFromString(item.bounds);
    imvPhoto.center = CGPointFromString(item.center);
    imvPhoto.transform = CGAffineTransformFromString(item.transform);
    imvPhoto.imgURL = item.photo;
    
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    
    [self.viewCard addSubview:imvPhoto];
}

-(void) addPhotoView: (UIImage *)image withURL:(NSString *) strURL
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    imvPhoto.imgURL = strURL;
    
    [self.viewCard addSubview:imvPhoto];
    currentPhoto = imvPhoto;
}

-(void) addPhotoView:(UIImage *)image withCenterPoint: (CGPoint)centerPoint andTransfrom: (CGAffineTransform) transform
{
    GestureImageView *imvPhoto = [[GestureImageView alloc] initWithImage:image];
    
    imvPhoto.imgURL = [self saveImagetoResources:image];
    
    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:imvPhoto inView:self.viewCard];
    imvPhoto.center = centerPoint;
    imvPhoto.transform = transform;
    [imvPhoto showShadow:YES];
    imvPhoto.delegate = self;
    
    [self.viewCard addSubview:imvPhoto];
}

-(void) flxibleFrameImage: (UIImage*) image withMaxValue:(CGFloat)maxValue forView: (UIView *)view inView: (UIView *) containerView
{
    CGSize sizeImage = image.size;
    CGSize sizeRatio;
    if (sizeImage.width > sizeImage.height) {
        sizeRatio.width = maxValue;
        sizeRatio.height = sizeImage.height/sizeImage.width * maxValue;
    }else
    {
        sizeRatio.height = maxValue;
        sizeRatio.width = sizeImage.width/sizeImage.height * maxValue;
    }
    [view setFrame:CGRectMake(0,0, sizeRatio.width, sizeRatio.height)];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
}

-(void) flxibleFrameImage: (UIImage*) image withMaxValue:(CGFloat)maxValue forView:(UIView*) view
{
    CGPoint centerPoint = view.center;
    [self flxibleFrameImage:image withMaxValue:maxValue forView:view inView:self.viewCard];
    view.center = centerPoint;
}

#pragma mark - GestureImage Delegate
-(void) displayEditor: (GestureImageView *)gestureImageView forImage:(UIImage *)imageToEdit
{
    currentPhoto = gestureImageView;
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}

#pragma mark - AFPhotoEditor
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
//    NSLog(@"%@" , NSStringFromCGSize(image.size));
//    [self flxibleFrameImage:image withMaxValue:kCanvasSize forView:currentPhoto inView:self.viewCard];
//    ((GestureImageView *)currentPhoto).image = image;
//
    CGPoint center = ((GestureImageView *)currentPhoto).center;
    CGAffineTransform transform = currentPhoto.transform;
    [self removeImageView];
    
    [self addPhotoView:image withCenterPoint:center andTransfrom:transform];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) selectImageView:(GestureImageView *)gestureImageView
{
    if (currentPhoto) {
        [currentPhoto showBorder:NO];
    }
    currentPhoto = gestureImageView;
    [currentPhoto showBorder:YES];
    NSLog(@"Select image view %@", gestureImageView);
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
}

- (IBAction)addAnimation:(id)sender {
}
- (IBAction)editPhoto:(id)sender {
}

- (IBAction)addMusic:(id)sender {
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
    [self addPhotoView:image];
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
    [self currentItemDeslected:currentPhoto];
}

-(void)currentItemDeslected : (GestureImageView *)currentItem
{
    [currentItem showBorder:NO];
    currentItem = nil;
}






@end
