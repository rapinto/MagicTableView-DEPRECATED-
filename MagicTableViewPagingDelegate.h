//
//  MagicTableViewPagingDelegate.h
//  Boast
//
//  Created by Raphael Pinto on 13/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MagicTableView;



@protocol MagicTableViewPagingDelegate <NSObject>


- (void)startLoadingForMagicTableView:(MagicTableView*)_MagicTableView;
- (void)stopLoadingForMagicTableView:(MagicTableView*)_MagicTableView;


@end
