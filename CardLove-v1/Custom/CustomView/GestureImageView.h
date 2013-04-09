//
//  GestureImageView.h
//  CardLove-v1
//
//  Created by FOLY on 3/9/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLImageView.h"

typedef enum {
    GestureImageViewToEdit,
    GestureImageViewToView
}GestureImageViewType;

@class GestureImageView;
@protocol GesturePhotoDelegate <NSObject>

@optional

-(void) displayEditor:(GestureImageView *)gestureImageView forImage: (UIImage *) imageToEdit;
-(void) selectImageView: (GestureImageView *) gestureImageView;

@end

@interface GestureImageView : OLImageView <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id<GesturePhotoDelegate> delegate;
@property (strong, nonatomic) NSString *imgURL;
@property (strong, nonatomic) NSString *elementID;

-(id) initWithImage:(UIImage *)image withType: (GestureImageViewType) type;

-(void) showShadow:(BOOL) show;
-(void) showBorder: (BOOL) show;


@end
