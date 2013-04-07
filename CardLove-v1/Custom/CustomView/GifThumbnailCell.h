//
//  GifThumbnailCell.h
//  CardLove-v1
//
//  Created by FOLY on 4/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifThumbnailView.h"

@interface GifThumbnailCell : UITableViewCell <UIGestureRecognizerDelegate>

-(GifThumbnailView *) gifViewByTag: (NSInteger) tag;

@end
