//
//  MusicViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/2/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"

@class MusicViewController;

@protocol MusicViewControllerDelegate <NSObject>

-(void) musicViewControllerDoneActionWithMusic: (NSString *) musicName;
-(void) musicViewControllerCancel;

@end

@interface MusicViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) id <MusicViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *listMusic;
@property (strong, nonatomic) NSString *selectingMusic;

@end
