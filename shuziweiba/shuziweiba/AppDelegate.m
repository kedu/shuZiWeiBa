//
//  AppDelegate.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "AppDelegate.h"
#import "YKWViewController.h"
#import "CommunityViewController.h"
#import "YKWMenuViewController.h"
#import "YKWTabarViewController.h"
#import <UMengSocialCOM/UMSocialSinaSSOHandler.h>
#import <UMengSocialCOM/UMSocial.h>
#import "UMSocialWechatHandler.h"
#import <AVOSCloud/AVOSCloud.h>
//#import "ZHNLeftSortViewController.h"
@interface AppDelegate ()
@property (nonatomic, strong) YKWMenuViewController *ykwLeft;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //单例
//    });
    //启动图时间0.9秒
    [NSThread sleepForTimeInterval:0.9];
    //leanCloud
//    [AVOSCloud setApplicationId:@"G8s08t3lJlKUpJHhMcrnYQn9-gzGzoHsz"
//                      clientKey:@"od5uCbldfFoLA53MDJDJMkEl"];
      [AVOSCloud setApplicationId:@"MNNGtXXe7whohO923p4UDH2v-gzGzoHsz" clientKey:@"2P9hDsh9Ln2RCzGl34ppfqBo"];
    //友盟appKey
    [UMSocialData setAppKey:@"571dbdf167e58e16600006a3"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1875986297"
                                              secret:@"5779e99f7c6d1680b1ffbac91be844ff"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //左侧视图
    YKWMenuViewController *leftVC = [YKWMenuViewController new];
    //主视图
    YKWTabarViewController *rootVC = [[YKWTabarViewController alloc]init];

    //UIWindow 上面的界面
     self.LeftSlideVC = [[ZHNLeftSlideViewController alloc]initWithLeftView:leftVC andMainView:rootVC];
    self.window.rootViewController = self.LeftSlideVC;

    return YES;
    
}
//友盟回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
