//
//  ModalPanelPickerView.m
//  CardLove-v1
//
//  Created by FOLY on 4/19/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "ModalPanelPickerView.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation ModalPanelPickerView

@synthesize tableView = _tableView;

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

-(void) layoutSubviews
{
    [super layoutSubviews];
    [_tableView setFrame:self.contentView.bounds];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
	}
	
    cell.imageView.image = [UIImage imageNamed:@"card-icon.jpg"];
	[cell.textLabel setText:[NSString stringWithFormat:@"Gift name %d", indexPath.row]];
	
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
    }];
}


@end
