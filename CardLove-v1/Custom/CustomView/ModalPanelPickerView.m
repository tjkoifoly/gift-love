//
//  ModalPanelPickerView.m
//  CardLove-v1
//
//  Created by FOLY on 4/19/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ModalPanelPickerView.h"
#import "UILabel+dynamicSizeMe.h"
#import "UIImageView+AFNetworking.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation ModalPanelPickerView
{
    
}

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize mode = _mode;
@synthesize result = _result;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!_result) {
            _result = [[NSMutableArray alloc] init];
        }
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
                NSString *pathGift = [[FunctionObject sharedInstance] dataFilePath:kProjects];
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
            {
                _dataSource = [NSMutableArray arrayWithArray:[[FriendsManager sharedManager] friendsList]];
            }
                break;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title mode: (ModalPickerMode) mode subArray:(NSArray *) array
{
    if ((self = [self initWithFrame:frame title:title])) {
        _mode = mode;
        
        switch (mode) {
            case ModalPickerFriends:
            {
                _dataSource = [NSMutableArray arrayWithArray:[[FriendsManager sharedManager] friendsList]];
                
                for(Friend *f in array)
                {
                    Friend *findFriend = [[FriendsManager sharedManager] friendByName:f.userName];
                    if (findFriend) {
                        [_dataSource removeObject:findFriend];
                    }
                }
                
            }
                break;
                
            case ModalPickerGifts:
            {
                NSString *pathGift = [[FunctionObject sharedInstance] dataFilePath:kProjects];
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
                
            case ModalPickerFriendsToSend:
            {
                _dataSource = [NSMutableArray arrayWithArray:[[FriendsManager sharedManager] friendsList]];
                
                for(Friend *f in array)
                {
                    Friend *findFriend = [[FriendsManager sharedManager] friendByName:f.userName];
                    if (findFriend) {
                        [_dataSource removeObject:findFriend];
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
            Friend *f = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", f.displayName];
            [cell.imageView setImage:[UIImage imageNamed:@"noavata.png"]];
            NSString *avatarLink = f.fAvatarLink;
            if (avatarLink!= (id)[NSNull null] && avatarLink.length != 0) {
                [cell.imageView setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"noavata.png"]];
            }

        }
            break;
            
        case ModalPickerFriendsToSend:
        {
            Friend *f = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", f.displayName];
            [cell.imageView setImage:[UIImage imageNamed:@"noavata.png"]];
            NSString *avatarLink = f.fAvatarLink;
            if (avatarLink!= (id)[NSNull null] && avatarLink.length != 0) {
                [cell.imageView setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"noavata.png"]];
            }  
        }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.accessoryType = UITableViewCellAccessoryNone;
    	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (_mode) {
            
        case ModalPickerFriends:
        {
            Friend *f = [_dataSource objectAtIndex:indexPath.row];
            
            if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddPersonToGroup object:f];
            }else if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemovePersonFromGroup object:f];
            }
            
            
        }
            break;
        case ModalPickerGifts:
        {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self hideWithOnComplete:^(BOOL finished) {
                NSLog(@"Panel hidden");
                NSString *giftName = [_dataSource objectAtIndex:indexPath.row];
                NSString *pathProjects = [[FunctionObject sharedInstance] dataFilePath:kProjects];
                NSString *pathGift = [pathProjects stringByAppendingPathComponent:giftName];
                
                NSString *pathPackages = [[FunctionObject sharedInstance] dataFilePath:kPackages];
                NSString *pathZip1 = [pathPackages stringByAppendingPathComponent:giftName];
                NSString *pathZip2 = [pathZip1 stringByAppendingPathExtension:@"zip"];
                
                [[FunctionObject sharedInstance] saveAsZipFromPath:pathGift toPath:pathZip2 withCompletionBlock:^(NSString *pathResult) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSendGiftToFriend object:pathResult];
                }];
            }];

        }
            break;
            
        case ModalPickerFriendsToSend:
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            Friend *f = [_dataSource objectAtIndex:indexPath.row];
            
            [self hideWithOnComplete:^(BOOL finished) {
                //[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSendGiftToFriend object:f];
                [self.delegate modalPanel:self didAddFriendToSendGift:f];
            }];
            
        }
            break;
            
        default:
            break;
    }

}



@end
