//
//  AppDelegate.h
//  CardLove-v1
//
//  Created by FOLY on 2/24/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GHMenuCell.h"
#import "GHMenuViewController.h"
#import "GHRootViewController.h"
#import "GHRevealViewController.h"
#import "GHSidebarSearchViewController.h"
#import "GHSidebarSearchViewControllerDelegate.h"

#import "FunctionObject.h"
#import "AJNotificationView.h"
#import "UserManager.h"
#import "MacroDefine.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate ,GHSidebarSearchViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) GHSidebarSearchViewController *searchController;
@property (nonatomic, strong) GHMenuViewController *menuController;

@property (nonatomic) NSInteger numRequest;
@property (nonatomic) NSInteger numNewMessages;
@property (nonatomic) NSInteger numNewGifts;

@property (strong, nonatomic) NSTimer *timerScheduleNotifications;

@property(nonatomic, strong) UIView *overlayView;

//DATA
@property (strong, nonatomic) NSString *user;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) getNotifications;
-(void) resetParams;
-(void) getNewGiftsWithCompletion:(NSTimer *)timerCompletionBlock;

@end
