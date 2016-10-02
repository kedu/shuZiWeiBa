//
//  DetailViewController.m
//  iReader
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "DetailModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+YKWxyz.h"
#import <SJIniteScrollView.h>
#import <MBProgressHUD.h>
//#import "UITableViewCell+cellhappy.h"
#import <UMengSocialCOM/UMSocialSinaSSOHandler.h>
#import <UMengSocialCOM/UMSocial.h>
#import "UMSocialWechatHandler.h"
#define kscrollheight self.view.frame.size.height / 5
#define kcollectionwidth self.view.frame.size.width / 2 - 15
@interface DetailViewController ()<UIWebViewDelegate,SJIniteScrollViewDelegate,UIWebViewDelegate>//UMSocialUIDelegate


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DetailModel *model;

@property (nonatomic, strong) UIImageView *newimageImage;
@property (nonatomic, strong) UILabel *newnLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger ziti;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NSString *abc;
@property (nonatomic, assign) NSInteger wid;
@property (nonatomic, strong) NSString *ormatString;
@end



@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    UIImage *loginImg = [UIImage imageNamed:@"nav_content_share_highlight"];
    loginImg = [loginImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIImage *da = [UIImage imageNamed:@"font_size_big"];
    da = [da imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *xiao = [UIImage imageNamed:@"font_size_small"];
    xiao = [xiao imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *shou = [UIImage imageNamed:@"menu_icon_favDown"];
    shou = [shou imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:loginImg style:(UIBarButtonItemStyleDone) target:self action:@selector(fenxiang)];
   UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:loginImg style:(UIBarButtonItemStyleDone) target:self action:@selector(fenxiang)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:da style:(UIBarButtonItemStyleDone) target:self action:@selector(jiadaziti)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithImage:xiao style:(UIBarButtonItemStyleDone) target:self action:@selector(jianxiaoziti)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithImage:shou style:(UIBarButtonItemStyleDone) target:self action:@selector(shoucang)];
    self.navigationItem.rightBarButtonItems = @[item1,item4,item2,item3];
    [self loadData];
    [self loadWebView];
    self.ziti = 18;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark webview头部
-(void)loadWebView{
    //打开交互
    self.mwebView.userInteractionEnabled = YES;
    //webView 设置头部偏移5分之2
    _mwebView.scrollView.contentInset= UIEdgeInsetsMake(kscrollheight*2,0,0,0);
    //去掉黑色框框
    _mwebView.scrollView.contentOffset= CGPointMake(0, -kscrollheight*5);
    //创建头部
    UIView * head = [[UIView alloc] initWithFrame:CGRectMake(0, -kscrollheight*2,[UIScreen mainScreen].bounds.size.width,kscrollheight*2)];
    // 给自定义view设个背景色
//    head.backgroundColor= [UIColor colorWithRed:0.9068 green:0.9722 blue:0.9657 alpha:1.0];

    // 把自定义的view添加到webView的scrollView上面!!!
    [_mwebView.scrollView addSubview:head];
    
    self.newimageImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, head.frame.size.width,[UIScreen mainScreen].bounds.size.height/5)];
    [head addSubview:_newimageImage];
    
    //详情的标题设置
    self.newnLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, kscrollheight+15, [UIScreen mainScreen].bounds.size.width-30, 70)];
    self.newnLabel.numberOfLines = 0;
    self.newnLabel.textAlignment = 1;
//    self.newnLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.432259316770186];
    self.newnLabel.textColor = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
    self.newnLabel.font = [UIFont systemFontOfSize:21];
    [head addSubview:self.newnLabel];
    //文章时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.newnLabel.frame), [UIScreen mainScreen].bounds.size.width, 50)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textAlignment = 1;
    self.timeLabel.textColor = [UIColor grayColor];
    [head addSubview:self.timeLabel];
}
- (void)loadData{
     self.dataArray  =[ NSMutableArray array];

    [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=view&aid=%@&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8",self.string] parameters:nil progress: nil success:^(NSURLSessionDataTask *task, id responseObject) {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict_a = responseObject[@"returnData"];
        NSDictionary *dictt = dict_a[@"article_content"];
        NSDictionary *dicttt = dict_a[@"articledata"];
        self.model = [[DetailModel alloc] init];

        [_model setValuesForKeysWithDictionary:dictt];
        [_model setValuesForKeysWithDictionary:dicttt];
//        [self.dataArray addObject:_model];
        [self.newimageImage sd_setImageWithURL:[NSURL URLWithString:_model.pic]];
        self.newnLabel.text = _model.title;
//        self.title = _model.title;
        self.timeLabel.text  =_model.dateline;
        _wid = self.mwebView.frame.size.width-15;
        //约束图片必备
        _str = [NSString stringWithFormat:@"<head><style>img{max-width:%ldpx !important;}</style></head>",_wid];
        _abc = [NSString stringWithFormat:@"%@%@",_str,_model.content];
        [self shuaxinWebView];
//        NSLog(@"%@",self.dataArray);
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
//webview加载页面
- (void)shuaxinWebView{
    //放大字体 偶也
    _ormatString = [NSString stringWithFormat:@"<span style=\"font-size:%ldpx;color:#525252\">%@</span>",self.ziti,_abc];
    
    [self.mwebView loadHTMLString:_ormatString baseURL:nil];

}



- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)fenxiang{
      [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"1875986297"
                                        shareText:[NSString stringWithFormat:@" http://www.dgtle.com/article-%@-1.html",self.string]
                                         shareImage:self.newimageImage.image
                                    shareToSnsNames:@[UMShareToSina,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:self];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = _model.title;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = _model.title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@" http://www.dgtle.com/article-%@-1.html",self.string];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@" http://www.dgtle.com/article-%@-1.html",self.string];
    
}
//加大字体
- (void)jiadaziti{
    NSInteger samll = self.ziti;
    self.ziti = samll+1;
    samll++;
    self.ziti = samll;
    [self shuaxinWebView];
    NSLog(@"%ld",self.ziti);

}

//减小字体
- (void)jianxiaoziti{
    
    NSInteger samll = self.ziti;
    self.ziti = samll-1;
    samll--;
    NSLog(@"%ld",self.ziti);
    [self shuaxinWebView];

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.mwebView loadHTMLString:htmlString baseURL:nil];
}
- (void)shoucang{
    NSLog(@"收藏成功");
}
//实现回调方法：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
