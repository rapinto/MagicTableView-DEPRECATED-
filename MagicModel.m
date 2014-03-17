//
//  MagicModel.m
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import "MagicModel.h"


#define kPagingPerPage 20


@implementation MagicModel



@synthesize mPage;
@synthesize mPerPage;
@synthesize mResults;
@synthesize mMagicModelDelegate;
@synthesize mRequestCallDeltaTime;
@synthesize mRequestKey;



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)init
{
    self = [super init];
    if (self)
    {
        _mLoadingType = kMagicTableViewLoadingType_NotLoading;
        self.mResults = [NSMutableArray array];
        self.mPerPage = [NSNumber numberWithInt:kPagingPerPage];
        self.mPage = [NSNumber numberWithInt:1];
        self.mRequestCallDeltaTime = 0;
        self.mRequestKey = [self description];
    }
    return self;
}


- (void)dealloc
{    
    [mRequestKey release];
    [mPage release];
    [mPerPage release];
    [mResults release];
    [mMagicModelDelegate release];
    [super dealloc];
}



#pragma mark -
#pragma mark Data Management Methods



- (void)setup
{
    if (self.mIsLoading)
    {
        return;
    }
    
    id lObj = [[NSUserDefaults standardUserDefaults] objectForKey:self.mRequestKey];
    
    BOOL lAlreadySent = YES;
    
    if ([lObj isKindOfClass:[NSDate class]])
    {
        NSDate* lLastCallTs = (NSDate*)lObj;
        
        if ([lLastCallTs timeIntervalSince1970] + self.mRequestCallDeltaTime < [[NSDate date] timeIntervalSince1970])
        {
            lAlreadySent = NO;
        }
    }
    else
    {
        lAlreadySent = NO;
    }
    
    
    if (!lAlreadySent)
    {
        _mLoadingType = kMagicTableViewLoadingType_Init;
        [self prepareRequestSending];
    }
    else
    {
        [self loadLocalResults];
        [self updatePagingEngine:self.mResults];
    }
}


- (void)pullToRefresh
{
    if (self.mIsLoading)
    {
        return;
    }
    _mLoadingType = kMagicTableViewLoadingType_PullToRefresh;
    [self prepareRequestSending];
}


- (void)paging
{
    if (self.mIsLoading)
    {
        return;
    }
    _mLoadingType = kMagicTableViewLoadingType_Paging;
    [self prepareRequestSending];
}


- (void)prepareRequestSending
{
    self.mIsLoading = YES;
    
    if (self.mLoadingType == kMagicTableViewLoadingType_Init || self.mLoadingType == kMagicTableViewLoadingType_PullToRefresh)
    {
        self.mPage = [NSNumber numberWithInt:1];
    }
    else if (self.mLoadingType == kMagicTableViewLoadingType_Paging)
    {
        self.mPage = [NSNumber numberWithInt:[self.mPage intValue] + 1];
    }
    
    [mMagicModelDelegate magicModelDisplayLoadingView:self];
    
    [self sendRequest];
}


- (void)requestFinish
{
    self.mIsLoading = NO;
    _mLoadingType = kMagicTableViewLoadingType_NotLoading;
}


- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults
{
    if (self.mLoadingType == kMagicTableViewLoadingType_PullToRefresh || self.mLoadingType == kMagicTableViewLoadingType_Init)
    {
        [self.mResults removeAllObjects];
    }
    
    [self.mResults addObjectsFromArray:_ReceivedResults];
    
            
    [mMagicModelDelegate magicModelResultsReceived:self];
    
    [self updatePagingEngine:_ReceivedResults];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.mRequestKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self requestFinish];
}


- (void)updatePagingEngine:(NSMutableArray*)_ReceivedResults
{
    if ([_ReceivedResults count] < [self.mPerPage intValue])
    {
        [self.mMagicModelDelegate magicModelDisablePaging:self];
    }
    else
    {
        [self.mMagicModelDelegate magicModelEnablePaging:self];
    }
}


- (void)didReceiveError
{
    [mMagicModelDelegate magicModelResultsReceived:self];
    
    [self requestFinish];
}


- (void)resetSearch
{
    self.mLoadingType = kMagicTableViewLoadingType_Init;
    [self prepareRequestSending];
}



#pragma mark -
#pragma mark To Be Overloaded Methods



- (void)sendRequest
{
}


- (void)loadLocalResults
{
    
}



#pragma mark -
#pragma mark Magic Table View Data Source Methods



- (BOOL)isLoadingMagicTableView:(MagicTableView*)_MagicTableView
{
    return self.mIsLoading;
}


- (void)magicTableViewDidTriggerPaging:(MagicTableView*)_MagicTableView
{
    [self paging];
}



#pragma mark -
#pragma mark Magic Pull To Refresh Delegate Methods



- (BOOL)isLoadingMagicPullToRefresh:(MagicPullToRefreshView*)_MagicPullToRefreshView
{
    return self.mIsLoading;
}


- (void)magicPullToRefreshDidTriggerPullToRefresh:(MagicPullToRefreshView*)_MagicPullToRefreshView
{
    [self pullToRefresh];
}


@end
