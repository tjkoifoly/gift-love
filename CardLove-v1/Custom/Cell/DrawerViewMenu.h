//
//  DrawerViewMenu.h
//  CardLove-v1
//
//  Created by FOLY on 3/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawerViewMenu;

@protocol DrawerMenuDelegate <NSObject>

- (void) updateContact: (NSIndexPath *) indexPath;
- (void) sendMessageTo: (NSIndexPath *) indexPath;
- (void) sendGiftTo: (NSIndexPath *) indexPath;
- (void) removeContact: (NSIndexPath *) indexPath;

@end

@interface DrawerViewMenu : UIView

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<DrawerMenuDelegate> delegate;

@end
