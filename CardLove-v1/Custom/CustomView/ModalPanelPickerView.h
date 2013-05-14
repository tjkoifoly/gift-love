//
//  ModalPanelPickerView.h
//  CardLove-v1
//
//  Created by FOLY on 4/19/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "UATitledModalPanel.h"
#import "MacroDefine.h"
#import "FriendsManager.h"
#import "FunctionObject.h"

typedef enum {
    ModalPickerGifts,
    ModalPickerFriends,
    ModalPickerFriendsToAdd
}ModalPickerMode;

@interface ModalPanelPickerView : UATitledModalPanel <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic) ModalPickerMode mode;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title mode: (ModalPickerMode) mode;

@end
