# SJIniteScrollView

This is an infinite photos play framework [前往Swift版](https://github.com/king129/SJIniteScrollViewSwift.git)

#### 效果演示

![](SJIniteScrollView.gif)

- 支持本地图片和`网络图片(最好设置占位图片)`
- 通过`block`或者`代理`监听图片点击

####更新日志

`2016-04-01`增加以下API和标题控件

```objective-c
/**
 *  清除内存缓存
 */
+ (void)clearMemoryCache;
/**
 *  清除磁盘缓存
 */
+ (void)clearDiskCache;
```

![](SJIniteScrollView2.gif)

### 基本用法

``` objective-c
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置本地数据
    self.view1.images = @[[UIImage imageNamed:@"image0"],
                               [UIImage imageNamed:@"image1"],
                               [UIImage imageNamed:@"image2"],
                               [UIImage imageNamed:@"image3"],
                               [UIImage imageNamed:@"image4"],
                               [UIImage imageNamed:@"image5"]
                               ];
//    self.view1.showPageControl = NO;
    // 设置滚动方向
    self.view1.direction = SJIniteScrollViewDirectionVertical;
    // 设置滚动时长
    self.view1.rollingTime = 5.0;

    // 设置pageControl 的一些属性
    [self.view2 setPageImage:[UIImage imageNamed:@"Star1"] currentPageImage:[UIImage imageNamed:@"Star2"]];

    // 设置网络数据
    self.view2.imagesUrl = @[@"http://www.bz55.com/uploads/allimg/150204/139-150204144514.jpg",
                                  @"http://bizhi.33lc.com/uploadfile/2015/0617/20150617053223353.jpg",
                                  @"http://www.bz55.com/uploads/allimg/150204/139-150204144513.jpg",
                                  @"http://ww2.sinaimg.cn/large/971d1e3fjw1emoibaghmuj20px0fgmzh.jpg",
                                  @"http://img2.3lian.com/2014/f4/30/d/56.jpg"];

    // 从网络加载 设置占位图片
    self.view2.placeholderImage = [UIImage imageNamed:@"image0"];
    // 监听图片点击
    [self.view2 didSelectItemIndex:^(NSInteger index) {
        NSLog(@"block监听图片点击,点击第%zd个", index);
    }];
}

#pragma mark ------------------------------------
#pragma mark  SJIniteScrollViewDelegate
- (void)initeScrollView:(SJIniteScrollView *)scrollView didSelectItemIndex:(NSInteger)index {
    NSLog(@"代理监听图片点击,点击第%zd个", index);
}
@end

```

###### 默认pageControl控件在右下角,如需更改位置请子类化,在子类中调整布局

``` objective-c
@implementation MyIniteScrollView

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat h = 30;
    CGFloat w = self.imagesUrl.count * h;
    CGFloat y = self.frame.size.height - h - 10;
    self.pageControl.frame = CGRectMake(0, y, w, h);
    self.pageControl.sj_centerX = self.sj_width * 0.5;
}

@end

```

### 安装

- CocoaPods

``` objective-c
pod 'SJIniteScrollView'
```

- 手动集成

``` 
将`SJIniteScrollView`文件夹拖入工程即可
```