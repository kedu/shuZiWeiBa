//
//  SJIniteScrollView.h
//  SJIniteScrollView
//
//  Created by king on 16/2/21.
//  Copyright © 2016年 king. All rights reserved.
//

//    The MIT License (MIT)
//
//    Copyright (c) 2016 king
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SJIniteScrollViewDirection) {
    
    SJIniteScrollViewDirectionHorizontal = 0, // 水平滚动
    SJIniteScrollViewDirectionVertical        // 垂直滚动
};
@class SJIniteScrollView;

@protocol SJIniteScrollViewDelegate <NSObject>
@optional
/**
 *  监听图片点击
 *
 *  @param scrollView 自身
 *  @param index      点击时对应的索引
 */
- (void)initeScrollView:(SJIniteScrollView *)scrollView didSelectItemIndex:(NSInteger)index;

@end
@interface SJIniteScrollView : UIView
/** 加载本地图片 */
@property (nonatomic, strong) NSArray<UIImage *> *images;
/** 加载网络图片 */
@property (nonatomic, strong) NSArray<NSString *> *imagesUrl;
/** 图片对应标题,标题数量必须和图片个数一致,否则设置无效 */
@property (nonatomic, strong) NSArray<NSString *> *titles;
/** 占位图片 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 滚动时长 */
@property (nonatomic, assign) NSTimeInterval rollingTime;
/** 是否显示pageContror */
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;
/** 滚动方向 */
@property (nonatomic, assign) SJIniteScrollViewDirection direction;
/** pageControl */
@property (nonatomic, weak,readonly) UIPageControl *pageControl;
/** titleLabel */
@property (nonatomic, weak,readonly) UILabel *titleLabel;
/** 代理 */
@property (nonatomic, weak) IBOutlet id<SJIniteScrollViewDelegate> delegate;
/**
 *  设置pageController图片(其中一个参数为空,则此项设置无效)
 *
 *  @param pageImage        其他图片
 *  @param currentPageImage 当前图片
 */
- (void)setPageImage:(UIImage *)pageImage currentPageImage:(UIImage *)currentPageImage;
/**
 *  监听图片点击
 *
 *  @param SelectBlock 图片点击时回调
 */
- (void)didSelectItemIndex:(void(^)(NSInteger index))SelectBlock;
/**
 *  清除内存缓存
 */
+ (void)clearMemoryCache;
/**
 *  清除磁盘缓存
 */
+ (void)clearDiskCache;
@end

/*************************** UIView扩展 ************************************/
@interface UIView(SJ)
@property (nonatomic, assign) CGFloat sj_width;
@property (nonatomic, assign) CGFloat sj_height;
@property (nonatomic, assign) CGFloat sj_x;
@property (nonatomic, assign) CGFloat sj_y;
@property (nonatomic, assign) CGFloat sj_centerX;
@property (nonatomic, assign) CGFloat sj_centerY;
@property (nonatomic, assign) CGFloat sj_right;
@property (nonatomic, assign) CGFloat sj_bottom;
@end