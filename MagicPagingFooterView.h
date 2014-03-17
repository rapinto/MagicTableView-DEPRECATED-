//
//  MagicPagingFooterView.h
//  Boast
//
//  Created by Raphael Pinto on 6/02/14.
//  Copyright (c) 2013 Raphael Pinto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagicTableViewPagingDelegate.h"



@interface MagicPagingFooterView : UIView <MagicTableViewPagingDelegate>


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mLoader;


@end
