//
//  MagicLoadingView.m
//
//
//  Created by Raphael Pinto on 06/02/2014.
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

#import "MagicLoadingView.h"

@implementation MagicLoadingView



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self startAnim];
    }
    
    return self;
}


- (void)dealloc
{
    [_mImageVIew release];
    [super dealloc];
}



#pragma mark -
#pragma mark Data Mangement Methods Methods



- (void)startAnim
{
    _mImageVIew.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loading_01.png"],
                                   [UIImage imageNamed:@"loading_02.png"],
                                   [UIImage imageNamed:@"loading_03.png"],
                                   [UIImage imageNamed:@"loading_04.png"],
                                   [UIImage imageNamed:@"loading_05.png"],
                                   [UIImage imageNamed:@"loading_06.png"],
                                   [UIImage imageNamed:@"loading_07.png"],
                                   [UIImage imageNamed:@"loading_08.png"],
                                   [UIImage imageNamed:@"loading_09.png"],
                                   [UIImage imageNamed:@"loading_10.png"],nil];
    _mImageVIew.animationDuration = 1;
    [_mImageVIew startAnimating];
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self startAnim];
}


@end
