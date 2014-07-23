//
//  MagicModel.h
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
@property (nonatomic) BOOL mIsPagingDisabled;
@property (nonatomic) BOOL mIsPagingEnded;
@property (nonatomic) int mRequestCallDeltaTime;
@property (nonatomic, retain) NSString* mRequestKey;
@property (nonatomic, retain) NSObject <MagicModelDelegate>* mMagicModelDelegate;


- (void)setup;
- (void)prepareRequestSending;

- (void)requestFinish;
- (void)resetList;

- (void)didReceiveResults:(NSMutableArray*)_ReceivedResults;
- (void)didReceiveError;

- (void)pullToRefresh;

- (void)sortResults;
- (void)sendRequest;
- (void)loadLocalResults;
- (void)paging;

- (void)updatePagingEngine:(NSMutableArray*)_ReceivedResults;

@end
