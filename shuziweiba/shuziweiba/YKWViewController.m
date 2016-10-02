//
//  YKWViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "YKWViewController.h"
#import "FirstTableViewCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "FirstModel.h"
#import "AppDelegate.h"
#import "UIView+YKWxyz.h"
#import "CommunityViewController.h"
#import "secondCollectionViewCell.h"
#import "ThirdViewController.h"
#import "DetailViewController.h"
#import "WC-ViewController.h"
//其他轮播
#import "SJIniteScrollView.h"
//轮播的小圆点位置
#import "MyIniteScrollView.h"
#import "ScorllViewModel.h"
#import <MBProgressHUD.h>
#define kscrollheight self.view.frame.size.height / 5
#define kcollectionwidth self.view.frame.size.width / 2 - 15
#define kcollectionheight 50
#define kLunBoTu_height 180
@interface YKWViewController ()<UITableViewDataSource,UITableViewDelegate,SJIniteScrollViewDelegate>
@property(nonatomic, strong) UIButton *openDrawerButton;

@property (weak, nonatomic) IBOutlet UITableView *YKWTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIButton *YkwSearchButton;
@property (nonatomic, weak) SJIniteScrollView *scvc;
@property (nonatomic, strong) NSMutableArray *ImageDataArray;
@property (nonatomic, strong) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation YKWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.tag = 101;
    //轮播出现问题在开启
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //背景颜色
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_logo"]];
    self.navigationItem.titleView = imageV;
    
    //搜索按钮
    self.YkwSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //搜索图片 防止渲染
    UIImage *searchImage = [UIImage imageNamed:@"group_search_icon"];
    searchImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:searchImage style:(UIBarButtonItemStyleDone) target:self action:@selector(searchButton)];
   
    [self.YkwSearchButton setImage:searchImage forState:UIControlStateNormal];

    
    
    //接收代理
    self.YKWTableView.delegate = self;
    self.YKWTableView.dataSource = self;
    
    //自定义cell行高
    self.YKWTableView.rowHeight = 265;
    //注册cell
    [self.YKWTableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //去掉分割线
    self.YKWTableView.separatorStyle = 0;
    //返回按钮
    UIImage *loginImg = [UIImage imageNamed:@"zone"];
    loginImg = [loginImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:loginImg style:(UIBarButtonItemStyleDone) target:self action:@selector(backView)];
    //新款吊炸天轮播
    [self lunbo];
    [self lunboLodata];
    //加载数据
    [self loadData];

    //调用刷新
    [self refresh];
    
    
    
}

-(void)lunboLodata{
    
    [[AFHTTPSessionManager manager] GET:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=diydata&apikeys=DGTLECOM_APITEST1&bid=274&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.scvc animated:YES];
        self.ImageDataArray = [NSMutableArray array];
        self.ImageArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        NSDictionary *dictionary = responseObject[@"returnData"];
        NSDictionary *dict = [dictionary[@"blocklist"] objectForKey:@"274"] ;
        
        NSArray *array = [dict allKeys];
        for (int i = 0; i < array.count; i ++) {
            NSString *string = array[i];
            NSDictionary *dic = dict[string];
            ScorllViewModel *scorllModel = [[ScorllViewModel alloc] init];
            [scorllModel setValuesForKeysWithDictionary:dic];
            [self.ImageDataArray addObject:scorllModel.Id];
            [self.ImageArray setObject:scorllModel.pic_url atIndexedSubscript:i];
            [self.titleArray setObject:scorllModel.title atIndexedSubscript:i];
            //轮播图网络地址
            self.scvc.imagesUrl = self.ImageArray;
            //轮播图文字
            self.scvc.titles = self.titleArray;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}
//第三方轮播
- (void)lunbo{
    //初始化轮播图
    SJIniteScrollView *scvc = [[SJIniteScrollView alloc] init];
    [MBProgressHUD showHUDAddedTo:scvc animated:YES];
    //轮播图占位符
    scvc.placeholderImage = [UIImage imageNamed:@"article_default_new"];
    scvc.rollingTime = 2.0;

    //轮播图属性
    self.scvc = scvc;
    scvc.delegate = self;
    scvc.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, kscrollheight);
    //添加一个头部视图 撑大 !头部多出的那一段文字
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kscrollheight+30)];
    [head addSubview:scvc];
    self.YKWTableView.tableHeaderView = head;
    
}
//返回按钮
- (void)backView{
    
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

//刷新方法和动画
- (void)refresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //动画
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 1; i < 11; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"whale%d", i]];
        [arr addObject:image];
    }
    
    // 设置普通状态的动画图片
    [header setImages:arr forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:arr forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:arr forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.YKWTableView.mj_header = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FirstModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


//搜索button 跳转
- (void)searchButton{
  
    ThirdViewController *viewcontroller = [ThirdViewController new];
    viewcontroller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:viewcontroller animated:YES];
    
    
}

//读取解析数据
- (void)loadData{

    [[AFHTTPSessionManager manager] GET:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=article&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&limit=0_20&modules=portal&order=dateline_desc&platform=ios&swh=480x800&version=2.8" parameters:nil progress: nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.dataArray = [NSMutableArray array];
        NSDictionary *dict_a = responseObject[@"returnData"];
        NSDictionary *dictt = dict_a[@"articlelist"];
        for (NSString *key in dictt) {
            
            NSDictionary *dic1 = [dictt objectForKey:key];
            FirstModel *model = [[FirstModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            //反向数据添加到0的位置
            [self.dataArray insertObject:model atIndex:0];
            
            
        }
        [self.YKWTableView.mj_header endRefreshing];

        NSLog(@"加载成功");
        [self.YKWTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    //以20的倍数增加
    
    self.YKWTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=article&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&limit=%lu_20&modules=portal&order=dateline_desc&platform=ios&swh=480x800&version=2.8",self.dataArray.count+20] parameters:nil progress: nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
            NSDictionary *dict_a = responseObject[@"returnData"];
            NSDictionary *dictt = dict_a[@"articlelist"];
            for (NSString *key in dictt) {
                
                NSDictionary *dic1 = [dictt objectForKey:key];
                
                FirstModel *model = [[FirstModel alloc] init];
                [model setValuesForKeysWithDictionary:dic1];
                
                //反向数据添加到0的位置
                [self.dataArray insertObject:model atIndex:self.dataArray.count];
                
                
            }
            [self.YKWTableView.mj_footer endRefreshing];
            NSLog(@"加载成功");
            [self.YKWTableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }];
    
//    NSLog(@"%ld",self.dataArray.count);
}
//cell跳转方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *shoCartVC = [DetailViewController new];
    
    FirstModel *model = self.dataArray[indexPath.row];
    shoCartVC.string = model.aid;
    //跳转消失tabbar
    shoCartVC.hidesBottomBarWhenPushed = YES;
//    shoCartVC.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:shoCartVC animated:YES];
}
//轮播点击方法
-(void)initeScrollView:(SJIniteScrollView *)scrollView didSelectItemIndex:(NSInteger)index{
    DetailViewController *detail = [[DetailViewController alloc]init];
    NSLog(@"%ld",(long)index);
    detail.string = self.ImageDataArray[index];
    //隐藏底部
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
