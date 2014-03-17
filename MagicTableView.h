//
//  MagicTableView.h
//  Boast
//
//  Created by Raphael Pinto on 05/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagicTableViewDelegate.h"
#import "MagicTableViewDataSource.h"
#import "MagicModelDelegate.h"
#import "MagicTableViewPagingDelegate.h"



@class MagicPullToRefreshView;



@interface MagicTableView : UITableView <UITableViewDelegate, MagicModelDelegate>


@property (nonatomic) BOOL mPagingDisabled;
@property (nonatomic) BOOL mPullToRefreshEnabled;
@property (nonatomic)float mLastContentOffset;
@property (nonatomic, assign) NSObject <MagicTableViewDelegate>* mMagicTableViewDelegate;
@property (nonatomic, assign) NSObject <MagicTableViewDataSource>* mMagicTableViewDataSource;
@property (nonatomic, retain) UIView<MagicTableViewPagingDelegate>* mPagingFooterView;
@property (nonatomic, retain) UIView* mEmptyStateView;
@property (nonatomic, retain) UIView* mLoadingView;
@property (nonatomic, retain) MagicPullToRefreshView* mPullToRefreshView;


- (void)updateEmptyStateView;


@end
