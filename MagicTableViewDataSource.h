//
//  MagicTableViewDataSource.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MagicTableView;



@protocol MagicTableViewDataSource <NSObject>



- (BOOL)isLoadingMagicTableView:(MagicTableView*)_MagicTableView;
- (void)magicTableViewDidTriggerPaging:(MagicTableView*)_MagicTableView;


@end
