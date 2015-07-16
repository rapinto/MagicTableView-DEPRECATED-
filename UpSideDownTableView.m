//
//  UpSideDownTableView.m
//  Dealabs
//
//  Created by Raphaël Pinto on 10/06/2015.
//  Copyright (c) 2015 HUME Network. All rights reserved.
//



#import "UpSideDownTableView.h"
#import "MagicPullToRefreshView.h"
#import "MagicModel.h"



@implementation UpSideDownTableView



#pragma mark -
#pragma mark UI Table View Delegate Methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Keep this empty to prevent magic table view paging
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.mPagingDisabled)
    {
        if (self.contentOffset.y < 50)
        {
            if ([self.mMagicTableViewDataSource respondsToSelector:@selector(isLoadingMagicTableView:)] && ![self.mMagicTableViewDataSource isLoadingMagicTableView:self])
            {
                [self.mMagicTableViewDataSource magicTableViewDidTriggerPaging:self];
                
                [self startLoadingTableViewPagingFooter];
                
                return;
            }
        }
    }
}


/*
#pragma mark -
#pragma mark Data Management Methods



- (float)totalCellsHeight
{
    NSInteger lNumberOfSection = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        lNumberOfSection = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    
    
    float lTotal = 0.0f;
    
    for (int i = 0; i < lNumberOfSection; i++)
    {
        NSInteger lNumberOfCells = 0;
        if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            lNumberOfCells = [self.dataSource tableView:self numberOfRowsInSection:i];
        }
        
        for (int y = 0; y < lNumberOfCells; y++)
        {
            UITableViewCell* lCell = [self.dataSource tableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForItem:y inSection:i]];
            
            lTotal += lCell.frame.size.height;
        }
    }
    
    
    return lTotal;
}*/



#pragma mark -
#pragma mark Magic Model Delgate Methods



- (void)magicModelDisablePaging:(MagicModel*)_MagicModel
{
    self.mPagingDisabled = YES;
    
    if (self.mPagingFooterView)
    {
        [self.mPagingFooterView stopLoadingForMagicTableView:self];
    }
    
    if (self.mDefaultFooterView)
    {
        self.tableHeaderView = self.mDefaultFooterView;
    }
}


- (void)magicModelEnablePaging:(MagicModel*)_MagicModel
{
    self.mPagingDisabled = NO;
    
    self.mPagingFooterView = [self.mMagicTableViewDelegate MagicTableViewPagingFooter:self];
    [self.mPagingFooterView startLoadingForMagicTableView:self];
    
    self.tableHeaderView = self.mPagingFooterView;
    
    float lOffsetY = MAX(self.contentSize.height - self.frame.size.height + 40, 0);
    [self setContentOffset:CGPointMake(0, lOffsetY) animated:NO];
}



- (void)addEmptyFooterView
{
    self.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.tableHeaderView.frame.size.height)] autorelease];
}


- (void)magicModelResultsReceived:(MagicModel*)_MagicModel forPage:(NSNumber*)_Page
{
    self.alwaysBounceVertical = NO;
    
    [self stopLoadingTableVIewPagingFooter];
    [self.mLoadingView removeFromSuperview];
    [self.mEmptyStateView removeFromSuperview];
    self.mEmptyStateView = nil;
    
    [self.mPullToRefreshView magicModelResultsReceived:_MagicModel forScrollView:self];
    
    [self updateEmptyStateView];
    
    float lCurrentContentHeight = self.contentSize.height;
    
    
    [self reloadData];
    
    
    if ([_Page intValue] == 1)
    {       
        float lOffsetY = MAX(self.contentSize.height - self.frame.size.height, 0);
        [self setContentOffset:CGPointMake(0, lOffsetY) animated:NO];
    }
    else
    {
        [self setContentOffset:CGPointMake(0, self.contentSize.height - lCurrentContentHeight ) animated:NO];
    }
}



@end
