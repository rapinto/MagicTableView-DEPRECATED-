//
//  MagicTableView.m
//  Boast
//
//  Created by Raphael Pinto on 05/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import "MagicTableView.h"
#import "MagicPullToRefreshView.h"



@implementation MagicTableView



@synthesize mPagingDisabled;
@synthesize mPullToRefreshEnabled;
@synthesize mLastContentOffset;
@synthesize mMagicTableViewDelegate;
@synthesize mMagicTableViewDataSource;
@synthesize mPagingFooterView;
@synthesize mPullToRefreshView;
@synthesize mLoadingView;



#pragma mark -
#pragma mark Object Life Cycle Methods Methods



- (void)dealloc
{
    [mLoadingView release];
    [mPullToRefreshView release];
    [mPagingFooterView release];
    [super dealloc];
}



#pragma mark -
#pragma mark Data Management Methods



- (BOOL)isTableViewEmpty
{
    NSInteger lNumberOfSection = 1;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        lNumberOfSection = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    
    for (int i = 0; i < lNumberOfSection; i++)
    {
        if ([self.dataSource tableView:self numberOfRowsInSection:i] > 0)
        {
            return NO;
            break;
        }
    }
    return YES;
}



#pragma mark -
#pragma mark UI Table View Delegate Methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (!self.mPagingDisabled)
	{
		if (mLastContentOffset - self.contentOffset.y < 0 && self.dragging)
		{
			if (self.contentSize.height - self.contentOffset.y <= self.frame.size.height)
			{
				if ([mMagicTableViewDataSource respondsToSelector:@selector(isLoadingMagicTableView:)] && ![mMagicTableViewDataSource isLoadingMagicTableView:self])
				{
					[mMagicTableViewDataSource magicTableViewDidTriggerPaging:self];
					       
                    [self startLoadingTableViewPagingFooter];
                    
                    return;
				}
			}
		}
	}
    
    mLastContentOffset = self.contentOffset.y;
}



#pragma mark -
#pragma mark View Update Methods



-(void)startLoadingTableViewPagingFooter
{
    [self.mPagingFooterView startLoadingForMagicTableView:self];
}


- (void)stopLoadingTableVIewPagingFooter
{
    [self.mPagingFooterView stopLoadingForMagicTableView:self];
}


- (void)updateEmptyStateView
{
    
    if ([self isTableViewEmpty])
    {
        self.mEmptyStateView = [self.mMagicTableViewDelegate MagicTableViewEmptyStateView:self];
        
        [self addSubview:self.mEmptyStateView];
    }
    else
    {
        [self.mEmptyStateView removeFromSuperview];
        self.mEmptyStateView = nil;
    }
}


- (void)displayLoadingView
{
    if ([self isTableViewEmpty])
    {
        self.mLoadingView = [self.mMagicTableViewDelegate MagicTableViewLoadingView:self];
        
        [self.superview insertSubview:self.mLoadingView aboveSubview:self];
    }
}


- (void)hideLoadingView
{
    [self.mLoadingView removeFromSuperview];
    self.mLoadingView = nil;
}



#pragma mark -
#pragma mark Magic Model Delgate Methods



- (void)magicModelDisablePaging:(MagicModel*)_MagicModel
{
    self.mPagingDisabled = YES;
    
    if (self.mPagingFooterView)
    {
        [self.mPagingFooterView stopLoadingForMagicTableView:self];
    }
}


- (void)magicModelEnablePaging:(MagicModel*)_MagicModel
{
    self.mPagingDisabled = NO;
    
    if (!self.tableFooterView)
    {
        self.mPagingFooterView = [self.mMagicTableViewDelegate MagicTableViewPagingFooter:self];
        self.tableFooterView = self.mPagingFooterView;
    }
}


- (void)magicModelResultsReceived:(MagicModel*)_MagicModel
{
    [self stopLoadingTableVIewPagingFooter];
    [self.mLoadingView removeFromSuperview];
    [self.mEmptyStateView removeFromSuperview];
    self.mEmptyStateView = nil;
    
    [self.mPullToRefreshView magicModelResultsReceived:_MagicModel forScrollView:self];
    
    [self updateEmptyStateView];
    
    [self reloadData];
}


- (void)magicModelDisplayLoadingView:(MagicModel*)_magicModel
{
    [self displayLoadingView];
    [self.mEmptyStateView removeFromSuperview];
    self.mEmptyStateView = nil;
}

@end