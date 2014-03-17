//
//  MagicPullToRefreshView.h
//  Boast
//
//  Created by Raphael Pinto on 6/02/14.
//  Copyright (c) 2013 Raphael Pinto. All rights reserved.
//

#import "MagicPullToRefreshView.h"
#import "MagicPullToRefreshDelegate.h"
#import "MagicModel.h"



#define FLIP_ANIMATION_DURATION 0.18f
#define kPullToRefreshViewHeight 40.0f


@implementation MagicPullToRefreshView



@synthesize mState;
@synthesize mLabel;
@synthesize mImageView;
@synthesize mActivityIndicator;
@synthesize mDelegate;




- (void)dealloc
{
    [mImageView release];
    [mActivityIndicator release];
    [mLabel release];
    [super dealloc];
}



#pragma mark -
#pragma mark Data Management Methods



- (void)initMagicPullToRefreshView
{
    self.mImageView = [CALayer layer];
    self.mImageView.frame = CGRectMake(75.0f, self.frame.size.height / 2 - 8, 12, 16);
    self.mImageView.contentsGravity = kCAGravityResizeAspect;
    self.mImageView.contents = (id)[UIImage imageNamed:@"refresh_down.png"].CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        self.mImageView.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:self.mImageView];
    
    [self setState:PullToRefreshNormal];
}


- (void)magicModelResultsReceived:(MagicModel*)_MagicModel forScrollView:(UIScrollView*)_ScrollView
{
	[self setState:PullToRefreshNormal];
    
    
    [UIView transitionWithView:_ScrollView duration:0.2 options:UIViewAnimationOptionCurveLinear animations:^
     {
         _ScrollView.contentInset = UIEdgeInsetsZero;
         
     }completion:^(BOOL finished){}];
}



#pragma mark -
#pragma mark View Update Methods



- (void)setState:(PullToRefreshState)_State
{
	switch (_State)
    {
		case PullToRefreshPulling:
            [self updateViewForPullingState];
			break;
		case PullToRefreshNormal:
			[self updateViewForNormalState];
			break;
		case PullToRefreshLoading:
			[self updateViewForRefreshState];
			break;
		default:
			break;
	}
	
	mState = _State;
}


- (void)updateViewForPullingState
{
    mActivityIndicator.hidden = YES;
    mLabel.text = NSLocalizedString(@"Stream.ReleaseToRefresh", @"");
    [CATransaction begin];
    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
    mImageView.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    [CATransaction commit];
}


- (void)updateViewForNormalState
{
    mActivityIndicator.hidden = YES;
    if (mState == PullToRefreshPulling) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        mImageView.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
    
    mLabel.text = NSLocalizedString(@"Stream.PullDownToRefresh", @"");
    [mActivityIndicator stopAnimating];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    mImageView.hidden = NO;
    mImageView.transform = CATransform3DIdentity;
    [CATransaction commit];
}


- (void)updateViewForRefreshState
{
    mImageView.hidden = YES;
    mLabel.text = NSLocalizedString(@"Stream.Loading", @"");
    mActivityIndicator.hidden = NO;
    [self.mActivityIndicator startAnimating];
}



#pragma mark -
#pragma mark ScrollView Methods



- (void)scrollViewDidScroll:(UIScrollView*)_ScrollView
{
    if (_ScrollView.contentOffset.y < 0)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                -_ScrollView.contentOffset.y);
        self.hidden = NO;
        
        if (_ScrollView.isDragging)
        {
            if (- _ScrollView.contentOffset.y >= kPullToRefreshViewHeight)
            {
                [self setState:PullToRefreshPulling];
            }
            else
            {
                [self setState:PullToRefreshNormal];
            }
        }
    }
    else
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                0);
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)_ScrollView willDecelerate:(BOOL)_Decelerate
{
	BOOL lLoading = NO;
	if ([mDelegate respondsToSelector:@selector(isLoadingMagicPullToRefresh:)])
    {
		lLoading = [mDelegate isLoadingMagicPullToRefresh:self];
	}
	
	if (_ScrollView.contentOffset.y <= - kPullToRefreshViewHeight && !lLoading)
	{
		if ([mDelegate respondsToSelector:@selector(magicPullToRefreshDidTriggerPullToRefresh:)])
        {
			[mDelegate magicPullToRefreshDidTriggerPullToRefresh:self];
		}
        
        
        [UIView transitionWithView:_ScrollView duration:0.5 options:UIViewAnimationOptionCurveLinear animations:^
         {
              _ScrollView.contentInset = UIEdgeInsetsMake(kPullToRefreshViewHeight, 0.0f, 0.0f, 0.0f);
		 }completion:^(BOOL finished){}];
       
        
		[self setState:PullToRefreshLoading];
	}
}


@end
