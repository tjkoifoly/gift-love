//
//  SSCollectionViewController.h
//  SSToolkit
//
//  Created by Sam Soffes on 8/26/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SSCollectionView.h"
#import "GHRootViewController.h"

/**
 Creates a controller object that manages a collection view.
 */
@interface SSCollectionViewController : UIViewController <SSCollectionViewDataSource, SSCollectionViewDelegate>
{
@private
	RevealBlock _revealBlock;
}

/**
 Returns the table view managed by the controller object. (read-only)
 */
@property (nonatomic, readonly) SSCollectionView *collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBlock: (RevealBlock)revealBlock;

@end
