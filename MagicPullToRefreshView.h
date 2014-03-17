//
//  MagicPullToRefreshView.h
//  Boast
//
//  Created by Raphael Pinto on 6/02/14.
//  Copyright (c) 2013 Raphael Pinto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullToRefreshPulling = 0,
	PullToRefreshNormal,
	PullToRefreshLoading,
} PullToRefreshState;


@class MagicModel;
@protocol MagicPullToRefreshDelegate;


@interface MagicPullToRefreshView : UIView <UITableViewDelegate>



@property (nonatomic, assign) NSObject <MagicPullToRefreshDelegate>* mDelegate;
@property (retain, nonatomic) IBOutlet CALayer *mImageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *mLabel;
@property (nonatomic) PullToRefreshState mState;


- (void)initMagicPullToRefreshView;
- (void)magicModelResultsReceived:(MagicModel*)_MagicModel forScrollView:(UIScrollView*)_ScrollView;

@end
