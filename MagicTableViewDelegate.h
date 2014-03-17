//
//  MagicTableViewDelegate.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MagicTableView;
@protocol MagicTableViewPagingDelegate;


@protocol MagicTableViewDelegate <NSObject>



- (UIView<MagicTableViewPagingDelegate>*)MagicTableViewPagingFooter:(MagicTableView*)_MagicTableView;
- (UIView*)MagicTableViewEmptyStateView:(MagicTableView*)_MagicTableView;
- (UIView*)MagicTableViewLoadingView:(MagicTableView*)_MagicTableView;




@end
