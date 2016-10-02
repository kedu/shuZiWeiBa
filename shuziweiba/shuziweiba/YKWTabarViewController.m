//
//  YKWTabarViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "YKWTabarViewController.h"
#import "YKWViewController.h"
#import "CommunityViewController.h"
//tabBar上文字颜色 接近图片选中色
#define ktitleColor  [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
@interface YKWTabarViewController ()

@end

@implementation YKWTabarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addChildViewController:[YKWViewController new] image:@"home" selectImage:@"home_act" title:@"首页"];
    [self addChildViewController:[CommunityViewController new] image:@"forum@2x.png" selectImage:@"forum_act@2x.png" title:@"社区"];

}
/** tabbar */
- (void)addChildViewController:(UIViewController *)viewController image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title {
    /** 设置navigationBarItem 和 tabbarItem title */
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    /** 设置tabBarItem title 样式 */
//    self.tabBar.tintColor = ktitleColor;
    /** 添加导航控制器 */
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
//    self.navigationController.navigationBar.tintColor = ktitleColor;
    [self addChildViewController:navigation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
