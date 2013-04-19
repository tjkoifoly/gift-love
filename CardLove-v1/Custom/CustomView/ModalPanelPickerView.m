//
//  ModalPanelPickerView.m
//  CardLove-v1
//
//  Created by FOLY on 4/19/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ModalPanelPickerView.h"
#import "UILabel+dynamicSizeMe.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation ModalPanelPickerView

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize mode = _mode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if ((self = [super initWithFrame:frame])) {
        CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
        
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.contentView addSubview:_tableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title mode: (ModalPickerMode) mode
{
    if ((self = [self initWithFrame:frame title:title])) {
        _mode = mode;
        
        switch (mode) {
            case ModalPickerFriends:
            {
                _dataSource = [NSMutableArray arrayWithArray:[[FriendsManager sharedManager] friendsList]];
            }
                break;
                
            case ModalPickerGifts:
            {
                NSString *pathGift = [[FunctionObject sharedInstance] dataFilePath:kPackages];
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                
                NSError *error = nil;
                NSArray *subDirs = [fileMgr contentsOfDirectoryAtPath:pathGift error:&error];
                
                _dataSource = [NSMutableArray arrayWithArray:subDirs];
                if ([_dataSource count] >0) {
                    if ([[_dataSource objectAtIndex:0] isEqual:@".DS_Store"]) {
                        [_dataSource removeObjectAtIndex:0];
                    }
                }

            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    [_tableView setFrame:self.contentView.bounds];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
	}
	
    switch (_mode) {
        case ModalPickerGifts:
        {
            cell.imageView.image = [UIImage imageNamed:@"card-icon.jpg"];
            cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];

        }
            break;
            
        case ModalPickerFriends:
        {
            cell.imageView.image = [UIImage imageNamed:@"avarta.jpg"];
            Friend *f = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", f.displayName];
        }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    [self hideWithOnComplete:^(BOOL finished) {
        NSLog(@"Panel hidden");
        switch (_mode) {
            case ModalPickerFriends:
            {
                Friend *f = [_dataSource objectAtIndex:indexPath.row];
                NSLog(@"PICK = %@", f);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatWithPerson object:f];
            }
                break;
            case ModalPickerGifts:
            {
                NSString *fileName = [_dataSource objectAtIndex:indexPath.row];
                NSString *pathPackages = [[FunctionObject sharedInstance] dataFilePath:kPackages];
                NSString *pathGift = [pathPackages stringByAppendingPathComponent:fileName];
                NSLog(@"PICK = %@", pathGift);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSendGiftToFriend object:pathGift];
            }
                break;
                
            default:
                break;
        }
    }];
}


@end
