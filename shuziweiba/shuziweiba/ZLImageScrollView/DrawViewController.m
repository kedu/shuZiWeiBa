//
//  DrawViewController.m
//  Drawer
//
//  Created by 向祖华 on 16/4/23.
//  Copyright © 2016年 向祖华. All rights reserved.
//

#import "DrawViewController.h"
#import "YKWViewController.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface DrawViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) YKWViewController *ykw;
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //手势
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        //手势的可用属性关掉
        [self.tap setEnabled:NO];
        //设置手势代理
        self.tap.delegate =self;
        //将手势添加到中间视图上
        [self.view addGestureRecognizer:self.tap];
    }
}
//设置中间视图
-(void)setRootViewController:(UITabBarController *)viewController{
    if (!viewController) {
        return;
    }
    //设置中间视图控制器
    [self.rootVC.view removeFromSuperview];
    self.rootVC = viewController;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    //判断，当在抽屉中选择选项的时候，会重新设置rootVC，先设置传入的VC的位置，这样效果会流畅写。可通过判断此时的手势是打开的，来设置fram
    if (self.tap.enabled == YES) {
        viewController.view.frame = CGRectMake(270, 0, kScreenW, kScreenH);
    }
    //展示中间视图
    [self showRootViewController:nil];
    //设置导航栏按钮
    [self setNavigationButton];
    
    
}
//展示中间视图
-(void)showRootViewController:(UIViewController *)viewController{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.rootVC.view.frame = CGRectMake(0, 0,kScreenW , kScreenH);
    }];
    //关掉手势
    [self.tap setEnabled:NO];
    //drawVC打开交互
    self.rootVC.view.userInteractionEnabled = YES;
}

//展示抽屉
-(void)showLeftViewController:(UIViewController *)viewController{
    //判断是否已经有抽屉视图（这里说的是视图，并不是说控制器，所以是必要的）
    if (![self.view.subviews containsObject:self.leftVC.view]) {
        //没有则将左视图插到最前面，即呈现抽屉
        [self.view insertSubview:self.leftVC.view atIndex:0];
    }
    //动画移动根视图
    [UIView animateWithDuration:0.5 animations:^{
        self.rootVC.view.frame = CGRectMake(270, 0, kScreenW, kScreenH);
    }];
    //打开手势
    [self.tap setEnabled: YES];
    //阻断交互
    self.rootVC.view.userInteractionEnabled = NO;
    
}
//设置导航栏按钮
-(void)setNavigationButton{
//    UIImage *hamburger = [UIImage imageNamed:@"zone"];
    //防止按钮呗渲染
//    hamburger = [hamburger imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *na = (UINavigationController *)self.rootVC;
    UIViewController *vc = na.viewControllers[0];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"抽屉" style:(UIBarButtonItemStyleDone) target:self action:@selector(openMenu)];
    
   
}
#pragma mark -- 事件
//打开抽屉按钮事件
-(void)openMenu{
    [self showLeftViewController:nil];
    //打开手势
    [self.tap setEnabled:YES];
    //关闭交互
    self.rootVC.view.userInteractionEnabled = NO;
}
//手势事件
-(void)tapAction{
    [self showRootViewController:nil];
    //关闭手势
    [self.tap setEnabled:NO];
    //打开交互
    self.rootVC.view.userInteractionEnabled = YES;
}
#pragma mark -- 手势的代理方法
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //如果手势点在rootVC上则执行操作
    if (gestureRecognizer == self.tap) {
        return CGRectContainsPoint(self.view.frame, [gestureRecognizer locationInView:self.rootVC.view]);
    }
    return YES;
}

@end
