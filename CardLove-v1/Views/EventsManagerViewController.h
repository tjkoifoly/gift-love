//
//  EventsManagerViewController.h
//  CardLove-v1
//
//  Created by FOLY on 3/15/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRootViewController.h"

@interface EventsManagerViewController : GHRootViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
