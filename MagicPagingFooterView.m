//
//  MagicPagingFooterView.h
//  Boast
//
//  Created by Raphael Pinto on 6/02/14.
//  Copyright (c) 2013 Raphael Pinto. All rights reserved.
//

#import "MagicPagingFooterView.h"

@implementation MagicPagingFooterView


- (void)dealloc
{
    [_mLoader release];
    [super dealloc];
}



#pragma mark -
#pragma mark Magic Table View Paging Delegate Methods



- (void)startLoadingForMagicTableView:(MagicTableView*)_MagicTableView
{
    self.mLoader.hidden = NO;
    [self.mLoader startAnimating];
}


- (void)stopLoadingForMagicTableView:(MagicTableView*)_MagicTableView
{
    self.mLoader.hidden = YES;
}



@end
