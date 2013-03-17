//
//  DrawerViewMenu.m
//  CardLove-v1
//
//  Created by FOLY on 3/7/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "DrawerViewMenu.h"
#import "HHPanningTableViewCell.h"

@implementation DrawerViewMenu

@synthesize delegate;
@synthesize indexPath = _indexPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - IBAction Methods
- (IBAction)updateInfor:(id)sender {
    ActionBlock block = ^{
        [self.delegate updateContact:self.indexPath];
    };
    
    [((HHPanningTableViewCell *)self.superview ) setDrawerRevealed:NO animated:YES competionBlock:block];
}

- (IBAction)chat:(id)sender {
    ActionBlock block = ^{
         [self.delegate sendMessageTo:self.indexPath];
    };
    
    [((HHPanningTableViewCell *)self.superview ) setDrawerRevealed:NO animated:YES competionBlock:block];
   
}

- (IBAction)present:(id)sender {
    ActionBlock block = ^{
        [self.delegate sendGiftTo:self.indexPath];
    };
    
    [((HHPanningTableViewCell *)self.superview ) setDrawerRevealed:NO animated:YES competionBlock:block];
    
}

- (IBAction)remove:(id)sender {
    ActionBlock block = ^{
       [self.delegate removeContact:_indexPath];
    };
    
    [((HHPanningTableViewCell *)self.superview ) setDrawerRevealed:NO animated:YES competionBlock:block];
    
}


@end
