//
//  MyIniteScrollView.m
//  SJIniteScrollViewExample
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "MyIniteScrollView.h"

@implementation MyIniteScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h = 30;
    CGFloat w = self.imagesUrl.count * h;
    CGFloat y = self.frame.size.height - h - 30;
    self.pageControl.frame = CGRectMake(0, y, w, h);
    self.pageControl.sj_centerX = self.sj_width * 0.5;
}

@end
