//
//  GestureImageView.h
//  CardLove-v1
//
//  Created by FOLY on 3/9/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLImageView.h"

@class GestureImageView;
@protocol GesturePhotoDelegate <NSObject>

-(void) displayEditor:(GestureImageView *)gestureImageView forImage: (UIImage *) imageToEdit;
-(void) selectImageView: (GestureImageView *) gestureImageView;

@end

@interface GestureImageView : OLImageView <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id<GesturePhotoDelegate> delegate;
@property (strong, nonatomic) NSString *imgURL;
@property (strong, nonatomic) NSString *elementID;

-(void) showShadow:(BOOL) show;
-(void) showBorder: (BOOL) show;


@end
