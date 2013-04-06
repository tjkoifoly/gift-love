//
//  PromptAlert.h
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptAlert : UIAlertView
{
    @private
    UITextField *fieldName_;
}

@property (nonatomic, strong) UITextField  *filedName;

-(id) initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles;

@end
