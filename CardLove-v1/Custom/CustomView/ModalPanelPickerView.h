//
//  ModalPanelPickerView.h
//  CardLove-v1
//
//  Created by FOLY on 4/19/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UATitledModalPanel.h"

@interface ModalPanelPickerView : UATitledModalPanel <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
