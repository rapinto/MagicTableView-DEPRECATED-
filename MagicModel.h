//
//  MagicModel.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicTableViewDataSource.h"
#import "MagicPullToRefreshDelegate.h"
#import "MagicModelDelegate.h"



typedef enum {
    kMagicTableViewLoadingType_NotLoading,
    kMagicTableViewLoadingType_Init,
    kMagicTableViewLoadingType_PullToRefresh,
    kMagicTableViewLoadingType_Paging,
}MagicTableViewLoadingType;



@interface MagicModel : NSObject <MagicTableViewDataSource, MagicPullToRefreshDelegate>


@property (nonatomic, retain) NSNumber* mPage;
@property (nonatomic, retain) NSNumber* mPerPage;
@property (nonatomic, retain) NSMutableArray *mResults;
@property ( nonatomic) MagicTableViewLoadingType mLoadingType;
@property (nonatomic) BOOL mIsLoading;
@property (nonatomic) int mRequestCallDeltaTime;
@property (nonatomic, retain) NSString* mRequestKey;
@property (nonatomic, retain) NSObject <MagicModelDelegate>* mMagicModelDelegate;


- (void)setup;
- (void)prepareRequestSending;

- (void)requestFinish;
- (void)resetSearch;

- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults;
- (void)didReceiveError;

- (void)pullToRefresh;

- (void)sortResults;
- (void)sendRequest;
- (void)loadLocalResults;

@end
