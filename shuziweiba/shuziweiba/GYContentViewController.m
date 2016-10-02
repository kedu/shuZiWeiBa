//
//  GYContentViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "GYContentViewController.h"
#import <AFNetworking.h>
#import "GYContentModel.h"
#import <MBProgressHUD.h>
#define kscrollheight self.view.frame.size.height / 5
#define kcollectionwidth self.view.frame.size.width / 2 - 15
@interface GYContentViewController ()
@property (nonatomic, strong) GYContentModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIWebView *YKWWebView;
@property (nonatomic, strong) UILabel *newnLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation GYContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hub.labelText = @"正在加载...";
    [self loadWebView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadWebView{
    //打开交互
    self.YKWWebView.userInteractionEnabled = YES;
    //webView 设置头部偏移5分之2
    self.YKWWebView.scrollView.contentInset= UIEdgeInsetsMake(kscrollheight*2,0,0,0);
    //去掉黑色框框
    self.YKWWebView.scrollView.contentOffset= CGPointMake(0, -kscrollheight*5);
    //创建头部
    UIView * head = [[UIView alloc] initWithFrame:CGRectMake(0, -kscrollheight*2,[UIScreen mainScreen].bounds.size.width,kscrollheight*2)];
    
    // 给自定义view设个背景色
        head.backgroundColor= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    // 把自定义的view添加到webView的scrollView上面!!!
    [self.YKWWebView.scrollView addSubview:head];
    

    
    //详情的标题设置
    self.newnLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, kscrollheight/3, [UIScreen mainScreen].bounds.size.width-30, 70)];
    self.newnLabel.numberOfLines = 0;
    self.newnLabel.textAlignment = 1;
    //    self.newnLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.432259316770186];
    self.newnLabel.textColor = [UIColor colorWithRed:0.498 green:0.498 blue:0.498 alpha:1.0];
    self.newnLabel.font = [UIFont systemFontOfSize:21];
    [head addSubview:self.newnLabel];
    //文章时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.newnLabel.frame), [UIScreen mainScreen].bounds.size.width, 50)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textAlignment = 1;
    self.timeLabel.textColor = [UIColor grayColor];
    [head addSubview:self.timeLabel];
}
- (void)loadData
{
    NSString *url = [NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=viewthread&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=forum&ordertype=1&platform=ios&swh=480x800&tid=%@&version=2.8", self.tid];
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"returnData"];
        self.dataArray = [NSMutableArray array];
        NSMutableArray *array = dic[@"postlist"];
        NSDictionary *dictionary = dic[@"thread"];
        
        NSDictionary *dicykw = array[0];
        self.model = [[GYContentModel alloc]init];
        [self.model setValuesForKeysWithDictionary:dicykw];
        [self.model setValuesForKeysWithDictionary:dictionary];
        NSInteger wid = self.YKWWebView.frame.size.width-15;
        
        self.newnLabel.text = _model.subject;
        self.timeLabel.text = [NSString stringWithFormat:@"作者 | %@",_model.author];
        //约束图片
        NSString *str = [NSString stringWithFormat:@"<head><style>img{max-width:%ldpx !important;}</style></head>",(long)wid];
        NSString *abc = [NSString stringWithFormat:@"%@%@",str,self.model.message];
        [self.YKWWebView loadHTMLString:abc baseURL:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
