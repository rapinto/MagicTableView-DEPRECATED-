//
//  MagicViewController.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagicTableViewDelegate.h"



@class MagicTableView, MagicModel, MagicPullToRefreshView;



@interface MagicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MagicTableViewDelegate>

@property (nonatomic, retain) IBOutlet MagicTableView* mTableView;
@property (nonatomic, retain) UIView* mPagingTableFooterView;
@property (nonatomic, retain) UIView* mLoadingView;
@property (nonatomic, retain) IBOutlet UIView* mEmptyStateView;
@property (nonatomic, retain) IBOutlet MagicPullToRefreshView* mPullToRefreshView;
@property (nonatomic, retain) MagicModel* mModel;
@property (nonatomic) BOOL mIsLoaded;


- (void)initMagicPullToRefreshView;
- (void)initDefaultLoadingView;


@end
