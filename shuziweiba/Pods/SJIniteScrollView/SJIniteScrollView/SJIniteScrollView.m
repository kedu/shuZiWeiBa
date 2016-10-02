//
//  SJIniteScrollView.m
//  SJIniteScrollView
//
//  Created by king on 16/2/21.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJIniteScrollView.h"

// 文件路径
#define FILEPATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"king"]

static NSString *const pageImageKey = @"_pageImage";
static NSString *const currentPageImageKey = @"_currentPageImage";

/** 图片内存缓存 */
static NSMutableDictionary *cacheImages_ = nil;

@interface SJIniteScrollView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) void(^MyBlock)(NSInteger);

/** 图片内存缓存 */
//@property (nonatomic, strong) NSMutableDictionary *cacheImages;
/** 队列 */
@property (nonatomic, strong) NSOperationQueue *queue;
/** 操作 */
@property (nonatomic, strong) NSMutableDictionary *operation;
@end

@implementation SJIniteScrollView
#pragma mark ------------------------------------
#pragma mark  初始化
+ (void)initialize {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:FILEPATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:FILEPATH withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    // 1.添加scrollView
    UIScrollView *scrollView = ({
        scrollView = [[UIScrollView alloc] init];
        // 初始化一些设置
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView;
    });
    
    // 2.添加3个imageView
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        [scrollView addSubview:imageView];
    }
    
    // 3.添加pageController
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    // 4.添加titleLabel
    UILabel *titleLabel = ({
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        titleLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.hidden = YES;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        titleLabel;
    });
    // 开启定时器
    [self startTime];

}
#pragma mark ------------------------------------
#pragma mark  懒加载
- (NSMutableDictionary *)cacheImages {
    if (cacheImages_ == nil) {
        cacheImages_ = [NSMutableDictionary dictionary];
    }
    return cacheImages_;
}
//- (NSMutableDictionary *)cacheImages {
//    
//    if (!_cacheImages) {
//        _cacheImages = [NSMutableDictionary dictionary];
//    }
//    return _cacheImages;
//}
- (NSOperationQueue *)queue {
    
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return  _queue;
}
- (NSMutableDictionary *)operation {
    
    if (!_operation) {
        _operation = [NSMutableDictionary dictionary];
    }
    return _operation;
}

#pragma mark ------------------------------------
#pragma mark  布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat scrollViewW = self.sj_width;
    CGFloat scrollViewH = self.sj_height;
    // scrollView
    self.scrollView.frame = self.bounds;
   
    if (_direction == SJIniteScrollViewDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(3 * scrollViewW, scrollViewH);
    } else {
        self.scrollView.contentSize = CGSizeMake(scrollViewW, 3 * scrollViewH);
    }
    // imageView
    for (NSInteger i = 0; i < 3; i++) {
        
        UIImageView *imageView = self.scrollView.subviews[i];
        if (_direction == SJIniteScrollViewDirectionHorizontal) {
            imageView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
        } else {
            imageView.frame = CGRectMake(0, i * scrollViewH, scrollViewW, scrollViewH);
        }
    }
    // pageControl
//    CGFloat pageControlW = 150;
//    CGFloat pageControlH = 30;
//    self.pageControl.frame = CGRectMake(scrollViewW - pageControlW + 10, scrollViewH - pageControlH, pageControlW, pageControlH);
#pragma mark修改pagecontroll居中
    //修改pagecontroll居中
    CGFloat h = 30;
    CGFloat w = self.imagesUrl.count * h;
    CGFloat y = self.frame.size.height - h - 30;
    self.pageControl.frame = CGRectMake(0, y+h, w, h);
    self.pageControl.sj_centerX = self.sj_width * 0.5;
    // titleLabel
    CGFloat titleLabelH = 30;
//    self.titleLabel.frame = CGRectMake(0, self.sj_height - titleLabelH, self.sj_width, titleLabelH);
      self.titleLabel.frame = CGRectMake(0, self.sj_height , self.sj_width, titleLabelH);
    // 更新内容
    [self updateCoenten];
}
#pragma mark ------------------------------------
#pragma mark  内部实现
- (void)setPageImage:(UIImage *)pageImage currentPageImage:(UIImage *)currentPageImage {
    if (pageImage == nil || currentPageImage == nil) return;
    [self.pageControl setValue:pageImage forKeyPath:pageImageKey];
    [self.pageControl setValue:currentPageImage forKeyPath:currentPageImageKey];
}
/**
 *  从网络下载
 *
 */
- (void)sj_setImageWithURL:(NSURL *)url imageView:(UIImageView *)imageView {
    
    NSMutableDictionary *cacheImages = [self cacheImages];
    
    UIImage *image = [cacheImages objectForKey:url];
    if (image) {
//        NSLog(@"--内存中有---");
        imageView.image = image;
    } else {
        NSString *imagePath = [self cachesDirWithUrl:url];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            imageView.image = image;
            [cacheImages setObject:image forKey:url];
//            NSLog(@"沙河中有这样的图片了");
        } else {
            imageView.image = self.placeholderImage;
            
            NSBlockOperation *download = [self.operation objectForKey:url];
            self.queue.maxConcurrentOperationCount = 5;
            
            if (download == nil) {
                download = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:data];
//                    NSLog(@"下载图片中-----");
                    if (image == nil) {
                        [self.operation removeObjectForKey:url];
                        return;
                    }
                    [cacheImages setObject:image forKey:url];
                    [data writeToFile:imagePath atomically:YES];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        imageView.image = image;
                    }];
                    [self.operation removeObjectForKey:url];
                }];
                [self.operation setObject:download forKeyedSubscript:url];
                [self.queue addOperation:download];
            }
        }
    }
}
- (NSString *)cachesDirWithUrl:(NSURL *)url {
    
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"king"];
//    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = url.absoluteString.lastPathComponent;
    return [FILEPATH stringByAppendingPathComponent:fileName];
}
#pragma mark ------------------------------------
#pragma mark  重写属性setter
- (void)setImages:(NSArray *)images {
    _images = images;
    self.pageControl.numberOfPages = images.count;
}
- (void)setImagesUrl:(NSArray *)imagesUrl {
    _imagesUrl = imagesUrl;
    self.pageControl.numberOfPages = imagesUrl.count;
}
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}
- (void)setRollingTime:(NSTimeInterval)rollingTime {
    _rollingTime = rollingTime;
    [self stopTimer];
    [self startTime];
}
#pragma mark ------------------------------------
#pragma mark  更新内容
/**
 *  更新所有UIImageView的内容，并且重置scrollView.contentOffset.x/y == 1倍宽度/高度
 */
- (void)updateCoenten {
   
    // 取出当前页码
    NSInteger page = self.pageControl.currentPage;
    // 更新imageView内容
    for (NSInteger i = 0; i < 3; i++) {
        
        UIImageView *imageView = self.scrollView.subviews[i];
        // 图片索引
        NSInteger index = 0;
        if (i == 0) { // 左边的ImageView
            index = page - 1;
        } else if (i == 1) { // 中间的ImageView
            index = page;
        } else { // 右边的ImageView
            index = page + 1;
        }
        // 处理特殊情况
        if (index == -1) {
            if (self.images) {
                index = self.images.count - 1;
            } else if (self.imagesUrl) {
                index = self.imagesUrl.count - 1;
            }
        } else if (index == self.images.count || index == self.imagesUrl.count) {
            index = 0;
        }
        if (self.images) {
            imageView.image = self.images[index];
        } else if (self.imagesUrl) {
            NSURL *url = [NSURL URLWithString:self.imagesUrl[index]];
            [self sj_setImageWithURL:url imageView:imageView];
        }
        imageView.tag = index;
    }
    
    if (self.titles && (self.titles.count == self.images.count || self.titles.count == self.imagesUrl.count)) {
        self.titleLabel.text = self.titles[page];
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.text = nil;
        self.titleLabel.hidden = YES;
    }
    // 重置scrollView.contentOffset.x / y == 1倍宽度/高度
    if (_direction == SJIniteScrollViewDirectionHorizontal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.sj_width, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.sj_height);
    }
}
#pragma mark ------------------------------------
#pragma mark  图片点击处理
- (void)imageViewClick:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(initeScrollView:didSelectItemIndex:)]) {
        [self.delegate initeScrollView:self didSelectItemIndex:tap.view.tag];
    }
    
    if (self.MyBlock) {
        self.MyBlock(tap.view.tag);
    }
}
- (void)didSelectItemIndex:(void (^)(NSInteger))SelectBlock {
    
    self.MyBlock = SelectBlock;
}
#pragma mark ------------------------------------
#pragma mark  外部方法
+ (void)clearDiskCache {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        BOOL successful = [[NSFileManager defaultManager] removeItemAtPath:FILEPATH error:nil];
        if (successful) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSFileManager defaultManager] createDirectoryAtPath:FILEPATH withIntermediateDirectories:YES attributes:nil error:NULL];
            });
        }
    });
}
+ (void)clearMemoryCache {
    [cacheImages_ removeAllObjects];
}
#pragma mark ------------------------------------
#pragma mark  定时器处理
- (void)startTime {
    
    NSTimeInterval timeInterval = self.rollingTime == 0 ? 3.0 : self.rollingTime;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextPage {
    if (_direction == SJIniteScrollViewDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.sj_width, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.sj_height) animated:YES];
    }
}
#pragma mark ------------------------------------
#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIImageView *tmpImageView  = nil;
    CGFloat minDelta = MAXFLOAT;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat delta = 0;
        if (_direction == SJIniteScrollViewDirectionHorizontal) {
            delta = ABS(self.scrollView.contentOffset.x - imageView.sj_x);
        } else {
            delta = ABS(self.scrollView.contentOffset.y - imageView.sj_y);
        }
        
        if (delta < minDelta) {
            minDelta = delta;
            tmpImageView = imageView;
        }
        
        self.pageControl.currentPage = tmpImageView.tag;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCoenten];
    [self startTime];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCoenten];
}
@end


/*************************** UIView扩展 ************************************/
@implementation UIView (SJ)
- (CGFloat)sj_width {
    return self.frame.size.width;
}
- (void)setSj_width:(CGFloat)sj_width {
    CGRect frame = self.frame;
    frame.size.width = sj_width;
    self.frame = frame;
}
- (CGFloat)sj_height{
    return self.frame.size.height;
}
- (void)setSj_height:(CGFloat)sj_height {
    CGRect frame = self.frame;
    frame.size.height = sj_height;
    self.frame = frame;
}
- (CGFloat)sj_x {
    return self.frame.origin.x;
}
- (void)setSj_x:(CGFloat)sj_x {
    CGRect frame = self.frame;
    frame.origin.x = sj_x;
    self.frame = frame;
}
- (CGFloat)sj_y {
    return self.frame.origin.y;
}
- (void)setSj_y:(CGFloat)sj_y {
    CGRect frame = self.frame;
    frame.origin.y = sj_y;
    self.frame = frame;
}
- (void)setSj_centerY:(CGFloat)sj_centerY {
    CGPoint center = self.center;
    center.y = sj_centerY;
    self.center = center;
}
- (CGFloat)sj_centerY {
    return self.center.y;
}
- (void)setSj_centerX:(CGFloat)sj_centerX {
    CGPoint center = self.center;
    center.x = sj_centerX;
    self.center = center;
}
- (CGFloat)sj_centerX {
    return self.center.x;
}
- (CGFloat)sj_right {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)sj_bottom {
    return CGRectGetMaxY(self.frame);
}
- (void)setSj_right:(CGFloat)sj_right {
    self.sj_x = sj_right - self.sj_width;
}
- (void)setSj_bottom:(CGFloat)sj_bottom {
    self.sj_y = sj_bottom - self.sj_height;
}
@end
