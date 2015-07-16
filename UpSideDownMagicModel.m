//
//  UpSideDownMagicModel.m
//  Dealabs
//
//  Created by Raphaël Pinto on 09/06/2015.
//  Copyright (c) 2015 HUME Network. All rights reserved.
//



#import "UpSideDownMagicModel.h"



@implementation UpSideDownMagicModel



#pragma mark -
#pragma mark Data Management Methods



- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults
{
    if (self.mLoadingType == kMagicTableViewLoadingType_PullToRefresh || self.mLoadingType == kMagicTableViewLoadingType_Init)
    {
        [self.mResults removeAllObjects];
    }
    
    for (id anObject in _ReceivedResults)
    {
        [self.mResults insertObject:anObject atIndex:0];
    }
    
    [self updatePagingEngine:_ReceivedResults];
    
    [self.mMagicModelDelegate magicModelResultsReceived:self forPage:self.mPage];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.mRequestKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self requestFinish];
}


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
    
    
    self.mLoadingType = kMagicTableViewLoadingType_Init;
    [self updatePageAndDispalayLoadingView];
    
    
    if (lAlreadySent)
    {
        [self loadLocalResults];
    }
    else 
    {
        [self sendRequest];
    }
}


@end
