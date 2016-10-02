//
//  DrawViewController.h
//  Drawer
//
//  Created by 向祖华 on 16/4/23.
//  Copyright © 2016年 向祖华. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MenuViewController.h"
#import "YKWMenuViewController.h"

@interface DrawViewController : UIViewController

@property(nonatomic,strong)UIViewController * leftVC;
@property(nonatomic,strong)UIViewController * rootVC;
@property(nonatomic,strong)UITapGestureRecognizer * tap;


//设置中间视图
-(void)setRootViewController:(UIViewController*)viewController;
//展示中间视图
-(void)showRootViewController:(UITabBarController*)viewController;
//展示抽屉视图
-(void)showLeftViewController:(UIViewController*)viewController;
-(void)setNavigationButton;
-(void)openMenu;
@end
