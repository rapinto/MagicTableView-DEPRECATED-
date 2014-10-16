//
//  HeaderInsetTableView.m
//  Dealabs
//
//  Created by Raphaël Pinto on 15/10/2014.
//  Copyright (c) 2014 HUME Network. All rights reserved.
//

#import "HeaderInsetTableView.h"

#import "HeaderInsetTableView.h"

@interface HeaderInsetTableView ()
{
    BOOL shouldManuallyLayoutHeaderViews;
}

- (void) layoutHeaderViews;

@end

@implementation HeaderInsetTableView

@synthesize headerViewInsets;

#pragma mark -
#pragma mark Super

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if(shouldManuallyLayoutHeaderViews)
        [self layoutHeaderViews];
}

#pragma mark -
#pragma mark Self

- (void) setHeaderViewInsets:(UIEdgeInsets)_headerViewInsets
{
    headerViewInsets = _headerViewInsets;
    
    shouldManuallyLayoutHeaderViews = !UIEdgeInsetsEqualToEdgeInsets(headerViewInsets, UIEdgeInsetsZero);
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Private

- (void) layoutHeaderViews
{
    const NSUInteger numberOfSections = self.numberOfSections;
    const UIEdgeInsets contentInset = self.contentInset;
    const CGPoint contentOffset = self.contentOffset;
    
    const CGFloat sectionViewMinimumOriginY = contentOffset.y + contentInset.top + headerViewInsets.top;
    
    //	Layout each header view
    for(NSUInteger section = 0; section < numberOfSections; section++)
    {
        UIView* sectionView = [self headerViewForSection:section];
        
        if(sectionView == nil)
            continue;
        
        const CGRect sectionFrame = [self rectForSection:section];
        
        CGRect sectionViewFrame = sectionView.frame;
        
        sectionViewFrame.origin.y = ((sectionFrame.origin.y < sectionViewMinimumOriginY) ? sectionViewMinimumOriginY : sectionFrame.origin.y);
        
        //	If it's not last section, manually 'stick' it to the below section if needed
        if(section < numberOfSections - 1)
        {
            const CGRect nextSectionFrame = [self rectForSection:section + 1];
            
            if(CGRectGetMaxY(sectionViewFrame) > CGRectGetMinY(nextSectionFrame))
                sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height;
        }
        
        if (sectionViewFrame.origin.y < self.contentOffset.y)
        {
            sectionViewFrame.origin.y = self.contentOffset.y;
        }
        
        [sectionView setFrame:sectionViewFrame];
    }
}

@end