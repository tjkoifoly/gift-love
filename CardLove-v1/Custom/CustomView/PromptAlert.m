//
//  PromptAlert.m
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "PromptAlert.h"
#import <QuartzCore/QuartzCore.h>

@implementation PromptAlert

@synthesize filedName = filedName_;

-(id) initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles
{
    if (self = [super initWithTitle:title message:@"\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        
        [self addSubview:self.filedName];
    }
    
    return self;
}

-(UITextField *) filedName
{
    if (!filedName_) {
		filedName_ = [[UITextField alloc] initWithFrame:CGRectZero];
        filedName_.frame = CGRectMake(12.0f, 45.0f, 260.0f, 28.0f);
        filedName_.background = [UIImage imageNamed:@"bg-txt.png"];
		filedName_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		filedName_.clearButtonMode = UITextFieldViewModeWhileEditing;
		filedName_.placeholder = @"Enter a name";
        [filedName_ becomeFirstResponder];
	}
	return filedName_;
}

@end
