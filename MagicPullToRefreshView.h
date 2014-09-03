//
//  MagicPullToRefreshView.h
// 
//
//  Created by Raphael Pinto on 6/02/14.
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


@property (retain, nonatomic) IBOutlet UIImageView *mImageView;

@property (nonatomic, assign) NSObject <MagicPullToRefreshDelegate>* mDelegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *mLabel;
@property (nonatomic) PullToRefreshState mState;


- (void)magicModelResultsReceived:(MagicModel*)_MagicModel forScrollView:(UIScrollView*)_ScrollView;
- (void)initMagicPullToRefreshView;


@end
