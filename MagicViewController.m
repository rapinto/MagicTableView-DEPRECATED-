//
//  MagicViewController.m
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

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



#pragma mark -
#pragma mark Object Life Cycle Methods



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initMagicViewController];
}


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
    [super dealloc];
}



#pragma mark -
#pragma mark Data Management Methods



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
        }
    }
    [self.mPullToRefreshView initMagicPullToRefreshView];
    
    [self.view insertSubview:self.mPullToRefreshView belowSubview:self.mTableView];
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
