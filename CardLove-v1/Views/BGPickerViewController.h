//
//  BGPickerViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/13/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGridView.h"
#import "MMGridViewDefaultCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MacroDefine.h"

@interface BGPickerViewController : UIViewController<MMGridViewDataSource, MMGridViewDelegate>

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) NSMutableDictionary *dictParent;

@property (strong, nonatomic) IBOutlet MMGridView *gridView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end