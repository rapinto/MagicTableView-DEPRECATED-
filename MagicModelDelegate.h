//
//  MagicModelDelegate.h
//  Boast
//
//  Created by Raphael Pinto on 06/02/2014.
//  Copyright (c) 2014 Raphael Pinto. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MagicModel;


@protocol MagicModelDelegate <NSObject>


- (void)magicModelDisplayLoadingView:(MagicModel*)_magicModel;
- (void)magicModelEnablePaging:(MagicModel*)_MagicModel;
- (void)magicModelResultsReceived:(MagicModel*)_MagicModel;
- (void)magicModelDisablePaging:(MagicModel*)_MagicModel;


@end
