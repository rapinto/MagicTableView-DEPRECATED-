//
//  MagicTableView.m
//
//
//  Created by Raphael Pinto on 05/02/2014.
//
// The MIT License (MIT)
// Copyright (c) 2014 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MagicTableView.h"
#import "MagicPullToRefreshView.h"
#import "MagicModel.h"



@implementation MagicTableView



@synthesize mPagingDisabled;
@synthesize mPullToRefreshEnabled;
@synthesize mLastContentOffset;
@synthesize mMagicTableViewDelegate;
@synthesize mMagicTableViewDataSource;
@synthesize mPagingFooterView;
@synthesize mPullToRefreshView;
@synthesize mLoadingView;
@synthesize mDefaultFooterView;



#pragma mark -
#pragma mark Object Life Cycle Methods Methods



- (void)dealloc
{
    [mLoadingView release];
    [mPullToRefreshView release];
    [mPagingFooterView release];
    [mDefaultFooterView release];
    [super dealloc];
}



#pragma mark -
#pragma mark Overrided Methods



- (void)reloadData
{
    [super reloadData];
    
    if (![mMagicTableViewDataSource isLoadingMagicTableView:self])
    {
        [self updateEmptyStateView];
    }
}


- (void)updateLoaders
{
    MagicTableViewLoadingType lCurrentLoadingType = [mMagicTableViewDataSource loadingMagicTableView:self];
    BOOL lIsEmpty = [self isTableViewEmpty];
    
    [self updateEmptyStateView];
    switch (lCurrentLoadingType)
    {
        case kMagicTableViewLoadingType_NotLoading:
        {
            if (lIsEmpty)
            {
                [self displayEmptyStateView];
            }
            else
            {
                [self hideEmptyStateView];
            }
            
            [self hideLoadingView];
            [self.mPagingFooterView stopLoadingForMagicTableView:self];
            break;
        }
        case kMagicTableViewLoadingType_Init:
        {
            [self hideEmptyStateView];
            [self displayLoadingView];
            [self.mPagingFooterView stopLoadingForMagicTableView:self];
            
            break;
        }
        case kMagicTableViewLoadingType_PullToRefresh:
        {
            [self hideEmptyStateView];
            [self displayLoadingView];
            [self.mPagingFooterView stopLoadingForMagicTableView:self];
            
            break;
        }
        case kMagicTableViewLoadingType_Paging:
        {
            [self hideEmptyStateView];
            [self hideLoadingView];
            [self.mPagingFooterView startLoadingForMagicTableView:self];
            break;
        }
        case kMagicTableViewLoadingType_ManualPaging:
        {
            [self hideEmptyStateView];
            [self hideLoadingView];
            [self.mPagingFooterView startLoadingForMagicTableView:self];
            break;
        }
        default:
            break;
    }
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


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.mLoadingView.frame = CGRectMake(self.mLoadingView.frame.origin.x,
                                         self.mLoadingView.frame.origin.y,
                                         self.frame.size.width,
                                         self.mLoadingView.frame.size.height);
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


- (void)scrollViewDidEndDragging:(UIScrollView *)_ScrollView willDecelerate:(BOOL)_Decelerate
{
    
}



#pragma mark -
#pragma mark View Update Methods



- (void)startLoadingTableViewPagingFooter
{
    [self.mPagingFooterView startLoadingForMagicTableView:self];
}


- (void)stopLoadingTableVIewPagingFooter
{
    if (self.mMagicTableViewDataSource && [self.mMagicTableViewDataSource isPagingEnded:self])
    {
        [self.mPagingFooterView stopLoadingForMagicTableView:self];
    }
}


- (void)updateEmptyStateView
{
    if ([self isTableViewEmpty])
    {
        [self displayEmptyStateView];
    }
    else
    {
        [self hideEmptyStateView];
    }
}


- (void)displayEmptyStateView
{
    self.mEmptyStateView = [self.mMagicTableViewDelegate MagicTableViewEmptyStateView:self];
    
    [self addSubview:self.mEmptyStateView];
}


- (void)hideEmptyStateView
{
    [self.mEmptyStateView removeFromSuperview];
    self.mEmptyStateView = nil;
}


- (void)tryToDisplayLoadingView
{
    if ([self isTableViewEmpty])
    {
        [self displayLoadingView];
    }
}


- (void)displayLoadingView
{
    self.mLoadingView = [self.mMagicTableViewDelegate MagicTableViewLoadingView:self];

    [self addSubview:self.mLoadingView];
    [self setNeedsDisplay];
    [self setNeedsLayout];
    [self.mLoadingView setNeedsLayout];
    [self.mLoadingView setNeedsDisplay];
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
    
    if (self.mDefaultFooterView)
    {
        self.tableFooterView = self.mDefaultFooterView;
    }
}


- (void)magicModelEnablePaging:(MagicModel*)_MagicModel
{
    self.mPagingDisabled = NO;
    
    self.mPagingFooterView = [self.mMagicTableViewDelegate MagicTableViewPagingFooter:self];
    [self.mPagingFooterView startLoadingForMagicTableView:self];
    
    CGPoint lOffset = self.contentOffset;
    self.tableFooterView = self.mPagingFooterView;
    self.contentOffset = lOffset;
}


- (void)magicModelResultsReceived:(MagicModel*)_MagicModel forPage:(NSNumber*)_Page
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
    if (_magicModel.mLoadingType == kMagicTableViewLoadingType_Init)
    {
        [self tryToDisplayLoadingView];
    }
    
    if (_magicModel.mLoadingType == kMagicTableViewLoadingType_Init ||
        _magicModel.mLoadingType == kMagicTableViewLoadingType_PullToRefresh)
    {
        [self addEmptyFooterView];
    }
    
    [self.mEmptyStateView removeFromSuperview];
    self.mEmptyStateView = nil;
}


- (void)addEmptyFooterView
{
    self.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.tableFooterView.frame.size.height)] autorelease];
}


@end
