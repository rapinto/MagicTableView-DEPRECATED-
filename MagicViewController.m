//
//  MagicViewController.m
//
//
//  Created by Raphael Pinto on 06/02/2014.
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

#import "MagicViewController.h"
#import "MagicTableView.h"
#import "MagicModel.h"
#import "MagicPagingFooterView.h"
#import "MagicPullToRefreshView.h"
#import "MagicLoadingView.h"



@interface MagicViewController ()

@end




@implementation MagicViewController



@synthesize mTableView;
@synthesize mModel;
@synthesize mPagingTableFooterView;
@synthesize mPullToRefreshView;
@synthesize mEmptyStateView;
@synthesize mLoadingView;
@synthesize mIsLoaded;
@synthesize mStopedAutoRefreshWhenReturningFromBackground;
@synthesize mIsPagingUpSideDown;



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self addMagicNotificationsObservers];
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initMagicViewController];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark Rotation handling Methods



- (void)handleRotationWithNewSize:(CGSize)size
{
    self.mLoadingView.frame = CGRectMake(0,
                                         self.mLoadingView.frame.origin.y,
                                         size.width,
                                         self.mLoadingView.frame.size.height);
    
    /*self.mPullToRefreshView.frame = CGRectMake(0,
                                               self.mPullToRefreshView.frame.origin.y,
                                               size.width,
                                               self.mPullToRefreshView.frame.size.height);*/
    
    mPagingTableFooterView.frame = CGRectMake(0,
                                              0,
                                              size.width,
                                              mPagingTableFooterView.frame.size.height);
}



#pragma mark -
#pragma mark Data Management Methods



- (void)addMagicNotificationsObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForground)
                                                 name:@"UIApplicationWillEnterForegroundNotification"
                                               object:nil];
}


- (void)willEnterForground
{
    if (!mStopedAutoRefreshWhenReturningFromBackground)
    {
        [self.mModel setup];
    }
}


- (void)initMagicViewController
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
            self.mPullToRefreshView.frame = CGRectMake(0,
                                                       0,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
        }
    }
    
    [self.mPullToRefreshView initMagicPullToRefreshView];
    
    [self.view insertSubview:self.mPullToRefreshView belowSubview:self.mTableView];
    
    self.mLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
    mPagingTableFooterView.frame = CGRectMake(0, 0, self.view.frame.size.width, mPagingTableFooterView.frame.size.height);
    
    self.mLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    self.mLoadingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.mLoadingView.frame.size.height);
    
    self.mLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    [self.mTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self.mPullToRefreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.mTableView respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.mTableView scrollViewDidEndDecelerating:scrollView];
    }
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
