//
//  MagicView.m
//
//
//  Created by Raphael Pinto on 06/03/2014.
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


#import "MagicView.h"
#import "MagicTableView.h"
#import "MagicModel.h"
#import "MagicPagingFooterView.h"
#import "MagicPullToRefreshView.h"
#import "MagicLoadingView.h"



@implementation MagicView



@synthesize mTableView;
@synthesize mModel;
@synthesize mPagingTableFooterView;
@synthesize mPullToRefreshView;
@synthesize mEmptyStateView;
@synthesize mLoadingView;



#pragma mark -
#pragma mark Object Life Cycle Methods



- (void)dealloc
{
    self.mTableView.delegate = nil;
    self.mTableView.dataSource = nil;
    self.mTableView.mMagicTableViewDataSource = nil;
    self.mTableView.mMagicTableViewDelegate = nil;
    self.mModel.mMagicModelDelegate = nil;
    self.mPullToRefreshView.mDelegate = nil;
    self.mTableView.mPullToRefreshView = nil;
    
    [mEmptyStateView release];
    [mPagingTableFooterView release];
    [mPullToRefreshView release];
    [mModel release];
    [mTableView release];
    [mLoadingView release];
    [super dealloc];
}



#pragma mark -
#pragma mark Data Management Methods



- (void)initMagicView
{
    if (!self.mIsLoaded)
    {
        [self initMagicModel];
        [self initMagicPullToRefreshView];
        
        
        self.mTableView.mMagicTableViewDataSource = self.mModel;
        self.mTableView.mMagicTableViewDelegate = self;
        self.mModel.mMagicModelDelegate = self.mTableView;
        self.mPullToRefreshView.mDelegate = self.mModel;
        self.mTableView.mPullToRefreshView = self.mPullToRefreshView;
        
        
        [self.mModel setup];
        
        self.mIsLoaded = YES;
    }
}


- (void)initMagicModel
{
    MagicModel* lMagicModel = [[MagicModel alloc] init];
    self.mModel = lMagicModel;
    [lMagicModel release];
}


- (void)initMagicPullToRefreshView
{
    NSArray* lNibArray = [[NSBundle mainBundle] loadNibNamed:@"MagicPullToRefreshView" owner:self options:nil];
    
    for (UIView* aView in lNibArray)
    {
        if ([aView isKindOfClass:[MagicPullToRefreshView class]])
        {
            self.mPullToRefreshView = (MagicPullToRefreshView*)aView;
        }
    }
    [self.mPullToRefreshView initMagicPullToRefreshView];
    
    [self insertSubview:self.mPullToRefreshView belowSubview:self.mTableView];
}


- (void)initDefaultPagingTableFooterView
{
    NSArray* lNibArray = [[NSBundle mainBundle] loadNibNamed:@"MagicPagingFooterView" owner:self options:nil];
    
    for (UIView* aView in lNibArray)
    {
        if ([aView isKindOfClass:[MagicPagingFooterView class]])
        {
            self.mPagingTableFooterView = aView;
        }
    }
    mPagingTableFooterView.frame = CGRectMake(0, 0, self.frame.size.width, mPagingTableFooterView.frame.size.height);
}


- (void)initDefaultLoadingView
{
    NSArray* lNibArray = [[NSBundle mainBundle] loadNibNamed:@"MagicLoadingView" owner:self options:nil];
    
    for (UIView* aView in lNibArray)
    {
        if ([aView isKindOfClass:[MagicLoadingView class]])
        {
            self.mLoadingView = aView;
        }
    }
    self.mLoadingView.frame = CGRectMake(0, 0, self.frame.size.width, self.mLoadingView.frame.size.height);
}



#pragma mark -
#pragma mark UI Table View Delegate Methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.mTableView scrollViewDidScroll:scrollView];
    [self.mPullToRefreshView scrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mPullToRefreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark Magic Table View Delegate Methods



- (UIView<MagicTableViewPagingDelegate>*)MagicTableViewPagingFooter:(MagicTableView*)_MagicTableView
{
    if (!self.mPagingTableFooterView)
    {
        [self initDefaultPagingTableFooterView];
    }
    
    return (UIView<MagicTableViewPagingDelegate>*)self.mPagingTableFooterView;
}


- (UIView*)MagicTableViewEmptyStateView:(MagicTableView*)_MagicTableView
{
    return mEmptyStateView;
}


- (UIView*)MagicTableViewLoadingView:(MagicTableView*)_MagicTableView
{
    if (!self.mLoadingView)
    {
        [self initDefaultLoadingView];
    }
    
    return self.mLoadingView;
}



#pragma mark -
#pragma mark Table View Data Source Methods



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"] autorelease];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mModel.mResults count];
}



@end
