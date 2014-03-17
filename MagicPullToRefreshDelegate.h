//
//  MagicPullToRefreshDelegate.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MagicPullToRefreshView;



@protocol MagicPullToRefreshDelegate <NSObject>



- (BOOL)isLoadingMagicPullToRefresh:(MagicPullToRefreshView*)_MagicPullToRefreshView;
- (void)magicPullToRefreshDidTriggerPullToRefresh:(MagicPullToRefreshView*)_MagicPullToRefreshView;



@end
