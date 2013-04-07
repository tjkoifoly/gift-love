//
//  GiftElementsViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifThumbnailView.h"
#import "GifThumbnailCell.h"
#import "MacroDefine.h"

@class GiftElementsViewController;
@protocol GiftElementsDelegate <NSObject>

-(void) giftElementsViewControllerDidSelected: (UIImage *) element;

@end

@interface GiftElementsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<GiftElementsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dictDataSource;

@end
