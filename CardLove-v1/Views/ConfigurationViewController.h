//
//  ConfigurationViewController.h
//  CardLove-v1
//
//  Created by FOLY on 4/12/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ConfigurationViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imvGiftPaper;
@property (weak, nonatomic) IBOutlet UIImageView *imvGiftFame;
@property (weak, nonatomic) IBOutlet UIImageView *imvGiftBackground;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;

@property (strong, nonatomic) NSString *pathGift;
@property (strong, nonatomic) NSMutableDictionary *dictGiftConfig;

@end
